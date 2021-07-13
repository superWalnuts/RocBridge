var { spawn } = require('child_process');
var { ArgumentParser } = require('argparse');
var os = require('os');
var inquirer = require('inquirer');
var fs = require('fs')

var parser = new ArgumentParser({
    add_help: true,
    description: 'Start a RocBridge js service.'
});

parser.add_argument(
    '-rd',
    {
        help: 'Set up the js service root directory.'
    }
);

parser.add_argument(
    '-port',
    {
        help: 'Set up the js service port.'
    }
);

var args = parser.parse_args();

let rootConfigPath = args['rd'];
if (!rootConfigPath) {
    rootConfigPath = "./node_modules/";
}
let assignPort = args['port'];
if (!assignPort) {
    assignPort = 0
}

let rooBridgeLogo = '\033[00;34m' + "\n   ___           ___      _    __        \n  / _ \___  ____/ _ )____(_)__/ /__ ____ \n / , _/ _ \/ __/ _  / __/ / _  / _ `/ -_)\n/_/|_|\___/\__/____/_/ /_/\_,_/\_, /\__/ \n                              /___/      \n"  + '\033[0m';

process.stdout.write(rooBridgeLogo);

let deviceIpArray = queryCurrentDeviceIp();

async function main() {
    if (!deviceIpArray || deviceIpArray.length == 0) {
        console.log('Get current device ip error！')
        return;
    }
    let currentIp = null;
    if (deviceIpArray.length > 1) {
        let promptList = [{
            type: 'rawlist',
            message: 'Please select the correct IP address:',
            name: 'ip',
            choices: deviceIpArray
        }];
        let answer = await inquirer.prompt(promptList);
        currentIp = answer.ip;
    } else {
        currentIp = ipArray[0];
    }

    let webPackCmd = `./node_modules/webpack/bin/webpack.js`;
    const webPackChild = spawn(webPackCmd, ["--config", `${rootConfigPath}RocBridge/local-config/webpack.config.dev.js`, "--watch", "--color"]);
    webPackChild.stdout.on('data', (data) => {
        console.log(`\n${data}`);
    });

    webPackChild.stderr.on('data', (data) => {
        console.log(`webPack error`);
        console.error(`\n${data}`);
    });

    webPackChild.on('exit', function (code, signal) {
        process.exit(0);
    });

    // let serverChild = spawn("node", [`${rootConfigPath}RocBridge/debug/debug_server.js`, '-rd', rootConfigPath, '-ip', currentIp, '-port', assignPort]);
    // serverChild.stdout.on('data', (data) => {
    //     console.log(`\n${data}`)
    // });

    // serverChild.stderr.on('data', (data) => {
    //     console.log(`server error`);
    //     console.error(`\n${data}`);
    // });

    process.stdin.resume();


    process.on('SIGINT', () => {
        webPackChild.kill();
        serverChild.kill();
        console.log("\n[+] Stop RocBridge server.");
        process.exit(0);
    });
}

// 如果为空工程创建脚手架
var mainTsIsExist = fs.existsSync('./main.ts');
var mainJsIsExist = fs.existsSync('./main.js');
var srcIsExist = fs.existsSync('./src');
if (!srcIsExist && !mainTsIsExist && !mainJsIsExist) {
    // 创建脚手架

    // 创建Main文件
    var demoMainPath = `${rootConfigPath}RocBridge/local-cli/staging/main.ts`;
    fs.writeFileSync('./main.ts', fs.readFileSync(demoMainPath));

    // 创建src文件夹
    fs.mkdirSync("./src");

    // 创建HelloWorld文件
    var demoHelloWorldPath = `${rootConfigPath}RocBridge/local-cli/staging/src/hello_world.ts`;
    fs.writeFileSync('./src/hello_world.ts', fs.readFileSync(demoHelloWorldPath));

    main();
} else {
    main();
}


function queryCurrentDeviceIp() {
    let ifaces = os.networkInterfaces();
    let ipArray = [];
    Object.keys(ifaces).forEach(function (ifname) {
        ifaces[ifname].forEach(function (iface) {
            if ('IPv4' !== iface.family || iface.internal !== false) {
                return;
            }
            ipArray.push(iface.address);
            ipAddress = iface.address;
        });
    });
    return ipArray;
}