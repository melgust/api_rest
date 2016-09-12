<?php

$cheque = $app['controllers_factory'];

$cheque->get('/cliente/lista', function () use ($app) {
  $sql = "select c.cliente_id, c.cliente_desc, c.nit, c.direccion, "
        ."(select sum(monto) from tt_cheque "
        ."where cliente_id = c.cliente_id) saldo "
        ."from tc_cliente c where exists ( "
        ."select * from tt_cheque cc "
        ."where c.cliente_id = cc.cliente_id and cc.estado_id = 1)";
  $rows = $app['db']->fetchAll( $sql, array() );
  return $app->json( resultArray( 'OK', 'Datos cargados', $rows ) );
});

$cheque->get('/cliente/{id}/lista', function ( $id ) use ($app) {
  $sql = "select * from tt_cheque "
        ."where cliente_id = ? and estado_id = 1";
  $rows = $app['db']->fetchAll( $sql, array( $id ) );
  return $app->json( resultArray( 'OK', 'Datos cargados', $rows ) );
});

$cheque->get('/buscar/{numero}/{cuenta}/lista', function ( $numero, $cuenta ) use ($app) {
  $sql = "select * from tt_cheque "
        ."where numero = ? and cuenta = ?";
  $rows = $app['db']->fetchAll( $sql, array( $numero, $cuenta ) );
  return $app->json( resultArray( 'OK', 'Datos cargados', $rows ) );
});

$cheque->get('/{cheque_id}', function ($cheque_id) use ($app) {
  $sql = "select cc.*, c.cliente_desc from tt_cheque cc "
        ."inner join tc_cliente c on cc.cliente_id = c.cliente_id "
        ."where cc.cheque_id = ?";
  $row = $app['db']->fetchAssoc( $sql, array($cuenta_id) );
  return $app->json( resultArray( 'OK', 'Datos cargados', $row ) );
});

$cheque->post('/add', function () use ($app) {
  $data = json_decode( file_get_contents("php://input"), true );
  try {
    $respuesta = null;
    $app['db']->beginTransaction();
    //actualizar saldo cuenta
    $sql = "select * from tt_cheque where cheque_id = ".$data['cheque_id'];
    $tmpdata = $app['db']->fetchAll($sql, array());
    if ($tmpdata[0]['monto'] >= $data['monto']) {
      $app['db']->update( 'tt_cheque', array(
        'fecha_cobro' => $data['fecha_cobro'],
        'usuario_modifica_id' => $data['usuario_id'],
        'estado_id' => 2
      ), array( 'cheque_id' => $data['cheque_id'] ) );
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

/*
$cheque->put('/edit', function () use ($app) {
  $data = json_decode( file_get_contents("php://input"), true );
  $app['db']->update( 'tc_cliente', $data, array( 'cliente_id' => $data['cliente_id'] ) );
  return $app->json( resultArray( 'OK', 'Datos actualizados', null ) );
});
*/

return $cheque;
