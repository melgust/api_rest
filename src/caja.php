<?php

$caja = $app['controllers_factory'];

$caja->get('/lista', function () use ($app) {
  $rows = $app['db']->fetchAll( "SELECT * FROM tc_caja order by caja_id desc", array() );
  return $app->json( resultArray( 'OK', 'Datos cargados', $rows ) );
});

$caja->get('/{caja_id}', function ($caja_id) use ($app) {
  $row = $app['db']->fetchAssoc( "SELECT * FROM tc_caja where caja_id = ?", array($caja_id) );
  return $app->json( resultArray( 'OK', 'Datos cargados', $row ) );
});

$caja->post('/add', function () use ($app) {
  $data = json_decode( file_get_contents("php://input"), true );
  $app['db']->insert('tc_caja', $data);
  return $app->json( resultArray( 'OK', 'Datos guardados', null ) );
});

$caja->put('/edit', function () use ($app) {
  $data = json_decode( file_get_contents("php://input"), true );
  $app['db']->update( 'tc_caja', $data, array( 'caja_id' => $data['caja_id'] ) );
  return $app->json( resultArray( 'OK', 'Datos actualizados', null ) );
});

return $caja;
