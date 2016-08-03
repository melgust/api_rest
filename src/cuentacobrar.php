<?php

$cuentacobrar = $app['controllers_factory'];

$cuentacobrar->get('/cliente/lista', function () use ($app) {
  $sql = "select c.cliente_id, c.cliente_desc, c.nit, c.direccion, "
        ."(select sum(saldo) from tt_cuenta_cobrar "
        ."where cliente_id = c.cliente_id) saldo "
        ."from tc_cliente c where exists ( "
        ."select * from tt_cuenta_cobrar cc "
        ."where c.cliente_id = cc.cliente_id and cc.estado = 1)";
  $rows = $app['db']->fetchAll( $sql, array() );
  return $app->json( resultArray( 'OK', 'Datos cargados', $rows ) );
});

$cuentacobrar->get('/cliente/{id}/lista', function ( $id ) use ($app) {
  $sql = "select * from tt_cuenta_cobrar "
        ."where cliente_id = ? and estado = 1";
  $rows = $app['db']->fetchAll( $sql, array( $id ) );
  return $app->json( resultArray( 'OK', 'Datos cargados', $rows ) );
});

$cuentacobrar->get('/{cuenta_id}', function ($cuenta_id) use ($app) {
  $sql = "select cc.*, c.cliente_desc from tt_cuenta_cobrar cc "
        ."inner join tc_cliente c on cc.cliente_id = c.cliente_id "
        ."where cc.cuenta_cobrar_id = ?";
  $row = $app['db']->fetchAssoc( $sql, array($cuenta_id) );
  return $app->json( resultArray( 'OK', 'Datos cargados', $row ) );
});

$cuentacobrar->post('/add', function () use ($app) {
  $data = json_decode( file_get_contents("php://input"), true );
  try {
    $respuesta = null;
    $app['db']->beginTransaction();
    //actualizar saldo cuenta
    $sql = "select * from tt_cuenta_cobrar where cuenta_cobrar_id = ".$data['cuenta_cobrar_id'];
    $tmpdata = $app['db']->fetchAll($sql, array());
    if ($tmpdata[0]['saldo'] >= $data['monto']) {
      //insertar abono a cuenta
      $app['db']->insert('tt_abono_cuenta', array(
        'monto' => $data['monto'],
        'estado' => 1,
        'fecha_registro' => date('Y-m-d H:i:s'),
        'usuario_id' => $data['usuario_id'],
        'cuenta_cobrar_id' => $data['cuenta_cobrar_id']
      ));
      $abonoId = $app['db']->lastInsertId();
      $saldo = $tmpdata[0]['saldo'] - $data['monto'];
      $estado = 1;
      if ($saldo <= 0) {
        $estado = 2;
      }
      $app['db']->update( 'tt_cuenta_cobrar', array(
        'saldo' => $saldo,
        'estado' => $estado
      ), array( 'cuenta_cobrar_id' => $data['cuenta_cobrar_id'] ) );
      $respuesta = $app->json(resultArray('OK', 'Proceso completado con éxito', $abonoId));
    } else {
      $respuesta = $app->json(resultArray('error', 'No puede  abonar más del saldo', null));
    }
    $app['db']->commit();
    return $respuesta;
  } catch (Exception $e) {
    $app['db']->rollBack();
    return $app->json(resultArray('error', $e->getMessage(), null));
  }
});

$cuentacobrar->put('/edit', function () use ($app) {
  $data = json_decode( file_get_contents("php://input"), true );
  $app['db']->update( 'tc_cliente', $data, array( 'cliente_id' => $data['cliente_id'] ) );
  return $app->json( resultArray( 'OK', 'Datos actualizados', null ) );
});

return $cuentacobrar;
