<?php

$inventario = $app['controllers_factory'];

$inventario->get('/lista', function () use ($app) {
  $sql = "select pp.*, pv.proveedor_desc, pr.producto_desc, pr.imagen_url, b.bodega_desc "
        ."from tt_ingreso_inventario pp "
        ."inner join tc_proveedor pv on pp.proveedor_id = pv.proveedor_id "
        ."inner join tc_producto pr on pp.producto_id = pr.producto_id "
        ."inner join tc_bodega b on pp.bodega_id = b.bodega_id "
        ."where pp.estado = 1 order by pp.ingreso_inventario_id desc ";
  $rows = $app['db']->fetchAll( $sql, array() );
  return $app->json( resultArray( 'OK', 'Datos cargados', $rows ) );
});

$inventario->get('/{ingreso_inventario_id}', function ($ingreso_inventario_id) use ($app) {
  $sql = "select pp.*, pv.proveedor_desc, pr.producto_desc, pr.imagen_url from tt_ingreso_inventario pp "
        ."inner join tc_proveedor pv on pp.proveedor_id = pv.proveedor_id "
        ."inner join tc_producto pr on pp.producto_id = pr.producto_id "
        ."where pp.ingreso_inventario_id = ?";
  $row = $app['db']->fetchAssoc( $sql, array($ingreso_inventario_id) );
  return $app->json( resultArray( 'OK', 'Datos cargados', $row ) );
});

$inventario->get('/producto/{producto_id}/proveedor/lista', function ($producto_id) use ($app) {
  $sql = "select pv.proveedor_id, pv.proveedor_desc from tc_proveedor_producto pp "
        ."inner join tc_proveedor pv on pp.proveedor_id = pv.proveedor_id "
        ."where pp.producto_id = ?";
  $row = $app['db']->fetchAll( $sql, array($producto_id) );
  return $app->json( resultArray( 'OK', 'Datos cargados', $row ) );
});

$inventario->get('/proveedor/{proveedor_id}/producto/lista', function ($proveedor_id) use ($app) {
  $sql = "select pv.producto_id, pv.producto_desc from tc_proveedor_producto pp "
        ."inner join tc_producto pv on pp.producto_id = pv.producto_id "
        ."where pp.proveedor_id = ?";
  $row = $app['db']->fetchAll( $sql, array($proveedor_id) );
  return $app->json( resultArray( 'OK', 'Datos cargados', $row ) );
});

$inventario->get('/productoproveedor/{producto_id}/{proveedor_id}', function ($producto_id, $proveedor_id) use ($app) {
  $sql = "select pp.*, pv.proveedor_desc, pr.producto_desc, pr.imagen_url, pr.existencia from tc_proveedor_producto pp "
        ."inner join tc_proveedor pv on pp.proveedor_id = pv.proveedor_id "
        ."inner join tc_producto pr on pp.producto_id = pr.producto_id "
        ."where pp.producto_id = ? and pp.proveedor_id = ?";
  $row = $app['db']->fetchAssoc( $sql, array($producto_id, $proveedor_id) );
  return $app->json( resultArray( 'OK', 'Datos cargados', $row ) );
});

$inventario->post('/agregar', function () use ($app) {
  $data = json_decode( file_get_contents("php://input"), true );
  try {
    $respuesta = null;
    //$app['db']->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $app['db']->beginTransaction();
    $items = $data['datos'];
    // insertar inventario
    for( $i = 0; $i < sizeof($items); $i++ ) {
      $app['db']->insert('tt_ingreso_inventario', array(
        'producto_id' => $items[$i]['producto_id'],
        'proveedor_id' => $items[$i]['proveedor_id'],
        'bodega_id' => $items[$i]['bodega_id'],
        'cantidad' => $items[$i]['cantidad'],
        'usuario_ingresa_id' => $items[$i]['usuario_id'],
        'no_envio' => $items[$i]['no_envio'],
        'lote' => $items[$i]['lote'],
        'fecha_vencimiento' => $items[$i]['fecha_vencimiento']
      ));
      $ingresoId = $app['db']->lastInsertId();
      /*actualizar proveedor y producto*/
      $sql = "select cantidad from tc_proveedor_producto where producto_id = ".$items[$i]['producto_id']." and proveedor_id = ".$items[$i]['proveedor_id'];
      $tmpdata = $app['db']->fetchAll($sql, array());
      $cantidad = $tmpdata[0]['cantidad'];
      $cantidad = $cantidad + $items[$i]['cantidad'];
      $app['db']->update( 'tc_proveedor_producto', array(
        'cantidad' => $cantidad
      ), array( 'producto_id' => $items[$i]['producto_id'], 'proveedor_id' => $items[$i]['proveedor_id'] ) );
      /*actualizar existencia producto*/
      $sql = "select existencia from tc_producto where producto_id = ".$items[$i]['producto_id'];
      $tmpdata = $app['db']->fetchAll($sql, array());
      $cantidad = $tmpdata[0]['existencia'];
      $cantidad = $cantidad + $items[$i]['cantidad'];
      $app['db']->update( 'tc_producto', array(
        'existencia' => $cantidad,
        'fecha_vencimiento' => $items[$i]['fecha_vencimiento']
      ), array( 'producto_id' => $items[$i]['producto_id'] ) );
    }
    $app['db']->commit();
    $respuesta = $app->json(resultArray('OK', 'Proceso completado con éxito', $items));
    return $respuesta;
  } catch (Exception $e) {
    $app['db']->rollBack();
    return $app->json(resultArray('error', $e->getMessage(), null));
  }
});

$inventario->put('/{ingreso_inventario_id}/anular', function ($ingreso_inventario_id) use ($app) {
  $data = json_decode( file_get_contents("php://input"), true );
  try {
    $respuesta = null;
    //$app['db']->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $app['db']->beginTransaction();
    /*Obtener datos del ingreso*/
    $sql = "select producto_id, cantidad from tt_ingreso_inventario where ingreso_inventario_id = ".$ingreso_inventario_id." and estado = 1";
    $tmpdata = $app['db']->fetchAll($sql, array());
    $productoId = $tmpdata[0]['producto_id'];
    $cantidadIng = $tmpdata[0]['cantidad'];
    /*actualizar existencia producto*/
    $sql = "select existencia from tc_producto where producto_id = ".$productoId;
    $tmpdata = $app['db']->fetchAll($sql, array());
    $cantidad = $tmpdata[0]['existencia'];
    if ($cantidad >= $cantidadIng) {
      $cantidad = $cantidad - $cantidadIng;
      $app['db']->update( 'tc_producto', array(
        'existencia' => $cantidad
      ), array( 'producto_id' => $productoId ) );
      $app['db']->update( 'tt_ingreso_inventario', array(
        'estado' => 0,
        'usuario_modifica_id' => $data['usuario_id'],
        'fecha_modifica' => date('Y-m-d H:i:s')
      ), array( 'ingreso_inventario_id' => $ingreso_inventario_id ) );
      $respuesta = $app->json(resultArray('OK', 'Ingreso anulado con éxito', null));
    } else {
      $respuesta = $app->json(resultArray('error', 'No es posible anular el ingreso debido a que la existencia es menor a lo que se quiere anular', null));
    }
    $app['db']->commit();
    return $respuesta;
  } catch (Exception $e) {
    $app['db']->rollBack();
    return $app->json(resultArray('error', $e->getMessage(), null));
  }
});

$inventario->post('/factura/lista', function () use ($app) {
  $data = json_decode( file_get_contents("php://input"), true );
  $where = "";
  if ($data['noFactura'] == 0) {
    $where = "f.fecha_inicio between STR_TO_DATE('".substr($data['fechaIni'], 0, strrpos($data['fechaIni'], "T"))."','%Y-%m-%d') and STR_TO_DATE('".substr($data['fechaFin'], 0, strrpos($data['fechaIni'], "T"))."','%Y-%m-%d')";
  } else {
    $where = "f.serie = '".strtoupper($data['serie'])."' and f.numero_factura = ".$data['noFactura'];
  }
  $sql = "select f.*, case f.estado when 1 then 'Activo' when 0 then 'Anulado' else 'Desconocido' end estado_desc, "
        ."c.cliente_id, c.cliente_desc, c.nit, c.direccion, f.usuario_modifica_id, u.usuario_desc "
        ."from tt_factura f "
        ."inner join tc_cliente c on f.cliente_id = c.cliente_id "
        ."left join tc_usuario u on f.usuario_modifica_id = u.usuario_id "
        ."where ".$where." order by f.factura_id";
  $row = $app['db']->fetchAll( $sql, array($ingreso_inventario_id) );
  return $app->json( resultArray( 'OK', 'Datos cargados', $row ) );
});

$inventario->post('/factura/{id}/anular', function ($id) use ($app) {
  $data = json_decode( file_get_contents("php://input"), true );
  if ($data['factura_id'] == $id) {
    try {
      $respuesta = null;
      //$app['db']->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
      $app['db']->beginTransaction();
      // insertar inventario
      $sql = "select count(1) conteo from tt_factura where factura_id = ".$data['factura_id']." and estado = 1";
      $dataFactura = $app['db']->fetchAll($sql, array());
      $cantidad = $dataFactura[0]['conteo'];
      if ( $cantidad > 0 ) {
        $app['db']->update( 'tt_factura', array('estado' => 0,
        'usuario_modifica_id' => $data['usuario_modifica_id'],
        'fecha_ult_modif' => date('Y-m-d H:i:s')), array( 'factura_id' => $data['factura_id'] ) );
        $sql = "select * from tt_detalle_factura where factura_id = ".$data['factura_id']." and estado = 1";
        $items = $app['db']->fetchAll($sql, array());
        for( $i = 0; $i < sizeof($items); $i++ ) {
          //calcular existencia
          $productoId = $items[$i]['producto_id'];
          $sql = "select existencia from tc_producto where producto_id = ".$productoId;
          $tmpdata = $app['db']->fetchAll($sql, array());
          $cantidadDisp = $tmpdata[0]['existencia'];
          $cantidadDisp = $cantidadDisp + $items[$i]['cantidad'];
          $app['db']->update( 'tc_producto', array('existencia' => $cantidadDisp), array( 'producto_id' => $productoId ) );
        }
        $respuesta = $app->json(resultArray('OK', 'Proceso completado con éxito', null));
      } else {
        $respuesta = $app->json(resultArray('error', 'La factura no existe o ya se encuentra anulada', $sql));
      }
      $app['db']->commit();
      return $respuesta;
    } catch (Exception $e) {
      $app['db']->rollBack();
      return $app->json(resultArray('error', $e->getMessage(), null));
    }
  }
});

return $inventario;
