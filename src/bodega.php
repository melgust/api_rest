<?php

$bodega = $app['controllers_factory'];

$bodega->get('/lista', function () use ($app) {
  $rows = $app['db']->fetchAll( "SELECT * FROM tc_bodega order by bodega_id desc", array() );
  return $app->json( resultArray( 'OK', 'Datos cargados', $rows ) );
});

$bodega->get('/{bodega_id}', function ($bodega_id) use ($app) {
  $row = $app['db']->fetchAssoc( "SELECT * FROM tc_bodega where bodega_id = ?", array($bodega_id) );
  return $app->json( resultArray( 'OK', 'Datos cargados', $row ) );
});

$bodega->post('/add', function () use ($app) {
  $data = json_decode( file_get_contents("php://input"), true );
  $app['db']->insert('tc_bodega', $data);
  return $app->json( resultArray( 'OK', 'Datos guardados', null ) );
});

$bodega->put('/edit', function () use ($app) {
  $data = json_decode( file_get_contents("php://input"), true );
  $app['db']->update( 'tc_bodega', $data, array( 'bodega_id' => $data['bodega_id'] ) );
  return $app->json( resultArray( 'OK', 'Datos actualizados', null ) );
});

return $bodega;
