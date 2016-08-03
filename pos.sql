-- --------------------------------------------------------
-- Host:                         chixot.com
-- Server version:               5.5.50-cll - MySQL Community Server (GPL)
-- Server OS:                    Linux
-- HeidiSQL Version:             9.3.0.4984
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table chixot_dev.tc_banco
CREATE TABLE IF NOT EXISTS `tc_banco` (
  `banco_id` int(11) NOT NULL AUTO_INCREMENT,
  `banco_desc` varchar(100) NOT NULL,
  PRIMARY KEY (`banco_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_bodega
CREATE TABLE IF NOT EXISTS `tc_bodega` (
  `bodega_id` int(11) NOT NULL AUTO_INCREMENT,
  `bodega_desc` varchar(50) NOT NULL,
  `estado` int(1) NOT NULL DEFAULT '1',
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_ult_modif` datetime DEFAULT NULL,
  PRIMARY KEY (`bodega_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_caja
CREATE TABLE IF NOT EXISTS `tc_caja` (
  `caja_id` int(11) NOT NULL,
  `caja_desc` varchar(100) NOT NULL,
  `estado` int(11) NOT NULL DEFAULT '1',
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `numero_factura` int(11) NOT NULL DEFAULT '0',
  `numero_inicial` int(11) NOT NULL DEFAULT '1',
  `numero_proforma` int(11) NOT NULL DEFAULT '0',
  `numero_envio` int(11) NOT NULL DEFAULT '0',
  `numero_fin` int(11) NOT NULL DEFAULT '9999999',
  `serie` varchar(10) NOT NULL,
  `tienda_id` int(11) NOT NULL,
  PRIMARY KEY (`caja_id`),
  KEY `idx_caja_tienda` (`tienda_id`),
  CONSTRAINT `fk_caja_tienda` FOREIGN KEY (`tienda_id`) REFERENCES `tc_tienda` (`tienda_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_categoria
CREATE TABLE IF NOT EXISTS `tc_categoria` (
  `categoria_id` int(11) NOT NULL AUTO_INCREMENT,
  `categoria_desc` varchar(150) NOT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` int(11) NOT NULL DEFAULT '1',
  `padre_id` int(11) DEFAULT NULL,
  `fecha_ult_modif` datetime DEFAULT NULL,
  PRIMARY KEY (`categoria_id`),
  KEY `fk_tc_categoria_idx` (`padre_id`),
  CONSTRAINT `fk_tc_categoria` FOREIGN KEY (`padre_id`) REFERENCES `tc_categoria` (`categoria_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_cliente
CREATE TABLE IF NOT EXISTS `tc_cliente` (
  `cliente_id` int(11) NOT NULL AUTO_INCREMENT,
  `cliente_desc` varchar(250) NOT NULL,
  `nit` varchar(10) NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `direccion` varchar(250) NOT NULL DEFAULT 'Ciudad',
  `fecha_nacimiento` date DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` int(11) NOT NULL DEFAULT '1',
  `fecha_ult_modif` datetime DEFAULT NULL,
  `tipo_cliente_id` int(11) NOT NULL,
  PRIMARY KEY (`cliente_id`),
  KEY `idx_tipo_cliente` (`tipo_cliente_id`),
  CONSTRAINT `fk_cliente_tipo` FOREIGN KEY (`tipo_cliente_id`) REFERENCES `tc_tipo_cliente` (`tipo_cliente_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_menu
CREATE TABLE IF NOT EXISTS `tc_menu` (
  `menu_id` int(11) NOT NULL AUTO_INCREMENT,
  `menu_desc` varchar(100) NOT NULL,
  `url` varchar(250) NOT NULL,
  `tooltip` varchar(100) NOT NULL,
  `icono` varchar(100) NOT NULL,
  `estado` int(11) NOT NULL DEFAULT '1',
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `padre_id` int(11) DEFAULT NULL COMMENT 'para recursividad, representa el menu_id padre',
  PRIMARY KEY (`menu_id`),
  KEY `fk_tc_menu_idx` (`padre_id`),
  CONSTRAINT `fk_tc_menu` FOREIGN KEY (`padre_id`) REFERENCES `tc_menu` (`menu_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_menu_perfil
CREATE TABLE IF NOT EXISTS `tc_menu_perfil` (
  `perfil_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`perfil_id`,`menu_id`),
  KEY `idx_perfil_menu` (`menu_id`),
  KEY `idx_menu_perfil` (`perfil_id`),
  CONSTRAINT `fk_menu_perfil` FOREIGN KEY (`menu_id`) REFERENCES `tc_menu` (`menu_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_perfil_menu` FOREIGN KEY (`perfil_id`) REFERENCES `tc_perfil` (`perfil_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_pago
CREATE TABLE IF NOT EXISTS `tc_pago` (
  `pago_id` int(11) NOT NULL AUTO_INCREMENT,
  `monto` decimal(11,2) NOT NULL,
  `cuenta_cobrar_id` int(11) DEFAULT NULL,
  `tipo_pago_id` int(11) NOT NULL,
  `factura_id` int(11) NOT NULL,
  `numero` int(11) DEFAULT NULL,
  `cuenta` varchar(15) DEFAULT NULL,
  `banco_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`pago_id`),
  KEY `idx_pago_cuenta_cobrar` (`cuenta_cobrar_id`),
  KEY `idx_pago_tipo_pago` (`tipo_pago_id`),
  KEY `idx_pago_factura` (`factura_id`),
  KEY `idx_pago_banco` (`banco_id`),
  CONSTRAINT `fk_pago_banco` FOREIGN KEY (`banco_id`) REFERENCES `tc_banco` (`banco_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_pago_cuenta_cobrar` FOREIGN KEY (`cuenta_cobrar_id`) REFERENCES `tt_cuenta_cobrar` (`cuenta_cobrar_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_pago_factura` FOREIGN KEY (`factura_id`) REFERENCES `tt_factura` (`factura_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_pago_tipo_pago` FOREIGN KEY (`tipo_pago_id`) REFERENCES `tc_tipo_pago` (`tipo_pago_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_perfil
CREATE TABLE IF NOT EXISTS `tc_perfil` (
  `perfil_id` int(11) NOT NULL AUTO_INCREMENT,
  `perfil_desc` varchar(100) NOT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` int(11) NOT NULL DEFAULT '1' COMMENT '0 = Inactivo\n1 = Activo',
  `fecha_ult_modif` datetime DEFAULT NULL,
  PRIMARY KEY (`perfil_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_precio
CREATE TABLE IF NOT EXISTS `tc_precio` (
  `precio_id` int(11) NOT NULL AUTO_INCREMENT,
  `precio` decimal(11,2) NOT NULL DEFAULT '0.00',
  `estado` int(11) NOT NULL DEFAULT '1',
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `tipo_cliente_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  PRIMARY KEY (`precio_id`),
  UNIQUE KEY `tipo_cliente_id_producto_id` (`tipo_cliente_id`,`producto_id`),
  KEY `idx_precio_tipo_cliente` (`tipo_cliente_id`),
  KEY `idx_precio_producto` (`producto_id`),
  CONSTRAINT `fk_precio_producto` FOREIGN KEY (`producto_id`) REFERENCES `tc_producto` (`producto_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_precio_tipo_cliente` FOREIGN KEY (`tipo_cliente_id`) REFERENCES `tc_tipo_cliente` (`tipo_cliente_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_producto
CREATE TABLE IF NOT EXISTS `tc_producto` (
  `producto_id` int(11) NOT NULL AUTO_INCREMENT,
  `producto_desc` varchar(200) NOT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` int(11) NOT NULL DEFAULT '1',
  `existencia` int(11) NOT NULL DEFAULT '0',
  `cantidad_minima` int(11) NOT NULL DEFAULT '0',
  `imagen_url` varchar(250) NOT NULL,
  `categoria_id` int(11) NOT NULL,
  `fecha_vencimiento` datetime DEFAULT NULL,
  PRIMARY KEY (`producto_id`),
  KEY `idx_producto_categoria` (`categoria_id`),
  CONSTRAINT `fk_producto_categoria` FOREIGN KEY (`categoria_id`) REFERENCES `tc_categoria` (`categoria_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_producto_imagen
CREATE TABLE IF NOT EXISTS `tc_producto_imagen` (
  `producto_imagen_id` int(11) NOT NULL AUTO_INCREMENT,
  `producto_imagen_desc` varchar(250) NOT NULL,
  `imagen_url` varchar(250) NOT NULL,
  `estado` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`producto_imagen_id`),
  KEY `producto_imagen_id` (`producto_imagen_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_proveedor
CREATE TABLE IF NOT EXISTS `tc_proveedor` (
  `proveedor_id` int(11) NOT NULL AUTO_INCREMENT,
  `proveedor_desc` varchar(100) NOT NULL,
  `telefono` varchar(15) NOT NULL,
  `contacto` varchar(100) NOT NULL,
  `direccion` varchar(250) NOT NULL,
  `nit` varchar(10) DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT '1',
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`proveedor_id`),
  UNIQUE KEY `UQ_NIT` (`nit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_proveedor_producto
CREATE TABLE IF NOT EXISTS `tc_proveedor_producto` (
  `proveedor_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT '0',
  `minimo` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`proveedor_id`,`producto_id`),
  KEY `idx_proveedor_producto` (`producto_id`),
  KEY `idx_producto_proveedor` (`proveedor_id`),
  CONSTRAINT `fk_producto_proveedor` FOREIGN KEY (`producto_id`) REFERENCES `tc_producto` (`producto_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_proveedor_producto` FOREIGN KEY (`proveedor_id`) REFERENCES `tc_proveedor` (`proveedor_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_tienda
CREATE TABLE IF NOT EXISTS `tc_tienda` (
  `tienda_id` int(11) NOT NULL AUTO_INCREMENT,
  `tienda_desc` varchar(100) NOT NULL,
  `telefono` varchar(100) DEFAULT NULL,
  `direccion` varchar(250) DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT '1',
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`tienda_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_tipo_cliente
CREATE TABLE IF NOT EXISTS `tc_tipo_cliente` (
  `tipo_cliente_id` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_cliente_desc` varchar(100) NOT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `limite_credito` decimal(11,0) NOT NULL,
  PRIMARY KEY (`tipo_cliente_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_tipo_pago
CREATE TABLE IF NOT EXISTS `tc_tipo_pago` (
  `tipo_pago_id` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_pago_desc` varchar(100) NOT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`tipo_pago_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_usuario
CREATE TABLE IF NOT EXISTS `tc_usuario` (
  `usuario_id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_desc` varchar(100) NOT NULL,
  `usuario` varchar(20) NOT NULL,
  `password` varchar(50) NOT NULL DEFAULT 'c69344a718eed85e3c03b2636c7e5d45451f995a',
  `estado` int(11) NOT NULL DEFAULT '1',
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_ult_modif` datetime DEFAULT NULL,
  PRIMARY KEY (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='tabla de usuarios para el sistema';

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tc_usuario_perfil
CREATE TABLE IF NOT EXISTS `tc_usuario_perfil` (
  `usuario_id` int(11) NOT NULL,
  `perfil_id` int(11) NOT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`usuario_id`,`perfil_id`),
  KEY `fk_tc_usuario_tc_perfil_tc_perfil1_idx` (`perfil_id`),
  KEY `fk_tc_usuario_tc_perfil_tc_usuario_idx` (`usuario_id`),
  CONSTRAINT `FK_tc_usuario_perfil_tc_perfil` FOREIGN KEY (`perfil_id`) REFERENCES `tc_perfil` (`perfil_id`),
  CONSTRAINT `fk_tc_usuario_tc_perfil_tc_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `tc_usuario` (`usuario_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tt_abono_cuenta
CREATE TABLE IF NOT EXISTS `tt_abono_cuenta` (
  `abono_cuenta_id` int(11) NOT NULL AUTO_INCREMENT,
  `monto` decimal(11,2) NOT NULL,
  `estado` int(11) NOT NULL DEFAULT '1',
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_id` int(11) NOT NULL,
  `cuenta_cobrar_id` int(11) NOT NULL,
  PRIMARY KEY (`abono_cuenta_id`),
  KEY `idx_abono_usuario` (`usuario_id`),
  KEY `idx_abono_cuenta_cobrar` (`cuenta_cobrar_id`),
  CONSTRAINT `fk_abono_cuenta_cobrar` FOREIGN KEY (`cuenta_cobrar_id`) REFERENCES `tt_cuenta_cobrar` (`cuenta_cobrar_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_abono_cuenta_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `tc_usuario` (`usuario_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tt_cuenta_cobrar
CREATE TABLE IF NOT EXISTS `tt_cuenta_cobrar` (
  `cuenta_cobrar_id` int(11) NOT NULL AUTO_INCREMENT,
  `cuenta_cobrar_desc` varchar(250) NOT NULL,
  `valor` decimal(11,2) NOT NULL,
  `saldo` decimal(11,2) NOT NULL,
  `estado` int(11) NOT NULL DEFAULT '1',
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_ult_modif` datetime DEFAULT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`cuenta_cobrar_id`),
  KEY `FK_tt_cuenta_cobrar_tc_cliente` (`cliente_id`),
  CONSTRAINT `FK_tt_cuenta_cobrar_tc_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `tc_cliente` (`cliente_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tt_detalle_factura
CREATE TABLE IF NOT EXISTS `tt_detalle_factura` (
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` int(11) NOT NULL DEFAULT '1' COMMENT '1 = Activo\n2 = Anulado',
  `precio_unidad` decimal(11,2) NOT NULL DEFAULT '0.00',
  `total` decimal(11,2) NOT NULL DEFAULT '0.00',
  `iva` decimal(11,2) NOT NULL DEFAULT '0.00',
  `factura_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `descuento` decimal(11,2) NOT NULL DEFAULT '0.00',
  `total_sin_iva` decimal(11,2) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL COMMENT 'Usuario que autoriza el descuento',
  KEY `idx_detalle_factura_producto` (`producto_id`),
  KEY `fk_detalle_factura` (`factura_id`),
  KEY `fk_detalle_fact_usuario` (`usuario_id`),
  CONSTRAINT `fk_detalle_factura` FOREIGN KEY (`factura_id`) REFERENCES `tt_factura` (`factura_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_fact_producto` FOREIGN KEY (`producto_id`) REFERENCES `tc_producto` (`producto_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_fact_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `tc_usuario` (`usuario_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tt_detalle_proforma
CREATE TABLE IF NOT EXISTS `tt_detalle_proforma` (
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` int(11) NOT NULL DEFAULT '1' COMMENT '1 = Activo\n2 = Anulado',
  `precio_unidad` decimal(11,2) NOT NULL DEFAULT '0.00',
  `total` decimal(11,2) NOT NULL DEFAULT '0.00',
  `iva` decimal(11,2) NOT NULL DEFAULT '0.00',
  `proforma_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `descuento` decimal(11,2) NOT NULL DEFAULT '0.00',
  `total_sin_iva` decimal(11,2) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL COMMENT 'Usuario que autoriza el descuento',
  KEY `idx_detalle_proforma_producto` (`producto_id`),
  KEY `fk_detalle_proforma` (`proforma_id`),
  KEY `fk_detalle_fact_usuario` (`usuario_id`),
  CONSTRAINT `fk_detalle_proforma` FOREIGN KEY (`proforma_id`) REFERENCES `tt_proforma` (`proforma_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_prof_producto` FOREIGN KEY (`producto_id`) REFERENCES `tc_producto` (`producto_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_prof_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `tc_usuario` (`usuario_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tt_factura
CREATE TABLE IF NOT EXISTS `tt_factura` (
  `factura_id` int(11) NOT NULL AUTO_INCREMENT,
  `fecha_inicio` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_fin` datetime DEFAULT NULL,
  `serie` varchar(10) NOT NULL,
  `numero_factura` int(11) DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT '1' COMMENT '1 = Iniciada\n2 = Suspendida\n3 = Finalizada\n4 = Anulada',
  `caja_id` int(11) NOT NULL,
  `total_producto` int(11) NOT NULL DEFAULT '0',
  `total` decimal(11,2) NOT NULL DEFAULT '0.00',
  `iva` decimal(11,2) NOT NULL DEFAULT '0.00',
  `descuento` decimal(11,2) NOT NULL DEFAULT '0.00',
  `total_sin_iva` decimal(11,2) NOT NULL DEFAULT '0.00',
  `cliente_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  PRIMARY KEY (`factura_id`),
  UNIQUE KEY `uq_serie_factura` (`serie`,`numero_factura`) COMMENT 'serie y numero seran unicos',
  KEY `idx_factura_caja` (`caja_id`),
  KEY `idx_factura_cliente` (`cliente_id`),
  KEY `idx_factura_usuario` (`usuario_id`),
  CONSTRAINT `fk_factura_caja` FOREIGN KEY (`caja_id`) REFERENCES `tc_caja` (`caja_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_factura_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `tc_cliente` (`cliente_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_factura_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `tc_usuario` (`usuario_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tt_ingreso_inventario
CREATE TABLE IF NOT EXISTS `tt_ingreso_inventario` (
  `ingreso_inventario_id` int(11) NOT NULL AUTO_INCREMENT,
  `producto_id` int(11) NOT NULL,
  `proveedor_id` int(11) NOT NULL,
  `bodega_id` int(11) DEFAULT NULL,
  `cantidad` int(5) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` int(1) NOT NULL DEFAULT '1',
  `usuario_ingresa_id` int(11) NOT NULL,
  `usuario_modifica_id` int(11) DEFAULT NULL,
  `fecha_modifica` datetime NOT NULL,
  `no_envio` int(11) DEFAULT NULL,
  `lote` varchar(50) DEFAULT NULL,
  `fecha_vencimiento` datetime DEFAULT NULL,
  PRIMARY KEY (`ingreso_inventario_id`),
  KEY `producto_id` (`producto_id`),
  KEY `proveedor_id` (`proveedor_id`),
  KEY `usuario_ingresa_id` (`usuario_ingresa_id`),
  KEY `usuario_modifica_id` (`usuario_modifica_id`),
  KEY `FK_tt_ingreso_inventario_tc_bodega` (`bodega_id`),
  CONSTRAINT `FK_tt_ingreso_inventario_tc_bodega` FOREIGN KEY (`bodega_id`) REFERENCES `tc_bodega` (`bodega_id`),
  CONSTRAINT `tt_ingreso_inventario_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `tc_producto` (`producto_id`),
  CONSTRAINT `tt_ingreso_inventario_ibfk_2` FOREIGN KEY (`proveedor_id`) REFERENCES `tc_proveedor` (`proveedor_id`),
  CONSTRAINT `tt_ingreso_inventario_ibfk_3` FOREIGN KEY (`usuario_ingresa_id`) REFERENCES `tc_usuario` (`usuario_id`),
  CONSTRAINT `tt_ingreso_inventario_ibfk_4` FOREIGN KEY (`usuario_modifica_id`) REFERENCES `tc_usuario` (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table chixot_dev.tt_proforma
CREATE TABLE IF NOT EXISTS `tt_proforma` (
  `proforma_id` int(11) NOT NULL AUTO_INCREMENT,
  `fecha_inicio` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_fin` datetime DEFAULT NULL,
  `serie` varchar(10) NOT NULL,
  `numero_proforma` int(11) DEFAULT NULL,
  `numero_envio` int(11) DEFAULT NULL,
  `tipo_id` int(11) NOT NULL DEFAULT '1',
  `estado` int(11) NOT NULL DEFAULT '1' COMMENT '1 = Iniciada\n2 = Suspendida\n3 = Finalizada\n4 = Anulada',
  `caja_id` int(11) NOT NULL,
  `total_producto` int(11) NOT NULL DEFAULT '0',
  `total` decimal(11,2) NOT NULL DEFAULT '0.00',
  `iva` decimal(11,2) NOT NULL DEFAULT '0.00',
  `descuento` decimal(11,2) NOT NULL DEFAULT '0.00',
  `total_sin_iva` decimal(11,2) NOT NULL DEFAULT '0.00',
  `cliente_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  PRIMARY KEY (`proforma_id`),
  KEY `idx_proforma_caja` (`caja_id`),
  KEY `idx_proforma_cliente` (`cliente_id`),
  KEY `idx_proforma_usuario` (`usuario_id`),
  CONSTRAINT `fk_proforma_caja` FOREIGN KEY (`caja_id`) REFERENCES `tc_caja` (`caja_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_proforma_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `tc_cliente` (`cliente_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_proforma_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `tc_usuario` (`usuario_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
