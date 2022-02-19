
var mysql = require('mysql');
var config = require('./config.json');

var pool = mysql.createPool({
	connectionLimit: 100,
  	host: config.dbhost,
  	user: config.dbuser,
  	password: config.dbpass,
  	database: config.dbname
});
exports.handler = (event,context,callback)=>{
	const done = ( err, res ) => callback( null, {
        statusCode: err ? '400' : '200',
        body: err ? err.message : JSON.stringify(res),
        headers:{ 'Access-Control-Allow-Origin' : '*' },
    });
	context.callbackWaitsForEmptyEventLoop = false;
	 pool.getConnection(function(err, connection) {
			connection.query("INSERT INTO rand_numbers (mm_operacion,mm_tran,mm_secuencia,mm_secuencial,mm_sub_secuencia,mm_fecha_aplicacion,mm_producto,mm_valor,mm_estado,mm_tipo,mm_beneficiario,mm_impuesto,mm_moneda,mm_valor_ext,mm_fecha_crea,mm_fecha_mod,mm_oficina, mm_fecha_real,mm_user,mm_tipo_cliente,mm_fecha_valor,mm_incremento,mm_usuario)"+
			" VALUES (2, CEIL(Rand() * (10000 + 5000)), CEIL(Rand() * (1 + 20)), CEIL(Rand() * (15000 + 30000)), 1, NOW(), lpad(conv(floor(Rand()*pow(36,5)), 10, 36), 4, 0), CEIL(Rand() * (1000 + 6000)), "+
			"'A' , 'B', 11, 0, 0, 0, NOW(), NOW(), 3346, NOW(), 'admuser', 'M', NOW(), 'S','admuser');", function (err, result, fields) {

			var iterador = 1000;

			for (var i = 0; i < iterador; i++) {
				con.query(sql, function (err, result) {
				if (err) throw err;
				//console.log("insertado con exito")
			  });   
			  }

      connection.release();
      // Handle error after the release.
			if (err) callback(err);
			else	callback(null,result);
			//else	callback(null,result);
			});
		});
};