var fs = require('fs');      
var net = require('net');
                                                                  
fs.watchFile(process.argv[3], function(curr,prev) {

	if (curr.mtime - prev.mtime) {
			 
		console.log("File changed");
		fs.readFile(process.argv[3], function(err,data) {

			client = net.createConnection(9999, process.argv[2]);
			client.write("PAYLOAD#-" + process.argv[3] + "\n");
			client.write(data);
			client.end();
		});
	}
	
});