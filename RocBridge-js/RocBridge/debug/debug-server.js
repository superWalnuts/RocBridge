var { ArgumentParser } = require('argparse');
var net = require('net');

var parser = new ArgumentParser({
    add_help: true,
    description: 'Start a RocBridge js debug server.'
})

parser.add_argument(
    '-rd',
    {
        help: 'Set up the js debug server root directory.'
    }
);

parser.add_argument(
    '-ip',
    {
        help: 'Set up the js debug server ip.'
    }
);

parser.add_argument(
    '-port',
    {
        help: 'Set up the js debug server port.'
    }
);

var args = parser.parse_args();

let rootConfigPath = args['rd'];
if (!rootConfigPath) {
    rootConfigPath = "./node_modules/";
}

let serverIp = args['ip'];
let portIncrease = 0;
let serverPort = args['port'];
if (!serverPort) {
    serverPort = 0
}

function getIp() {
    return serverIp;
}

function getPort() {
    return parseInt(serverPort) + (portIncrease++);
}


function getFreePort(callback) {
    let server = net.createServer().listen(getPort());
    server.on('listening', function () {
        let port = server.address().port;
        console.log(port + ' is free.');
        server.close()
        callback(port);
    });

    server.on('error', function (err) {
        console.log(port + ' is busy.');
        callback(-1);
    });
}

let httpServer = null;
getFreePort((port)=>{
    if (port < 0) {
        return;
    }
    httpServer = new RocBridgeHttpServer(port);
});



class RocBridgeHttpServer {
    constructor(port) {
        let express = require('express');
        this.server = express();

        let bodyParser = require('body-parser');
        this.server.use(bodyParser.json({ limit: '50mb' }));
        this.server.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));

        this.port = port;
        this.fs = require('fs');

        this.registerHttpHandler.call(this);
    }

    registerHttpHandler() {
        this.server.get('/bundle.js', (req, res) => {
            console.log('registerHttpHandler request');

            this.fs.readFile('./build/bundle.js', 'utf-8', (err, data) => {
                if (err) {
                    throw err;
                }

                let serverInfo = { httpServerPort: this.port, ip: getIp() };
                let additionMsg = "// ^^^^^^^^" + JSON.stringify(serverInfo) + '^^^^^^^^ \n';
                res.send(additionMsg + data);
            });
        });

        this.server.listen(this.port, null,null, ()=>{
            console.log('\u001b[00;35mBundle url: \u001b[00;32mhttp://' + getIp() + ':' + this.port + '/bundle.js\u001b[0m');
        })
    }
}