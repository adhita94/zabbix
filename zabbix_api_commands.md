### Checking Server Version
- `curl -s -X POST -H 'Content-Type: application/json-rpc' -d '{"jsonrpc":"2.0","method":"apiinfo.version","id":"1","auth":null,"params":{}}' 'http://18.219.31.166/zabbix/api_jsonrpc.php'`
- `curl -s -X POST -H 'Content-Type: application/json-rpc' -d '{"jsonrpc":"2.0","method":"apiinfo.version","id":"1","auth":null,"params":{}}' 'http://18.219.31.166/zabbix/api_jsonrpc.php' | jq "."`

### Fetching Hosts Details
- `curl -s -X POST -H 'Content-Type: application/json-rpc' -d '{"jsonrpc":"2.0","method":"user.login","id":"1","auth":null,"params":{"user":"Admin","password":"zabbix"}}' 'http://18.219.31.166/zabbix/api_jsonrpc.php' | jq "."`
- `curl -s -X POST -H 'Content-Type: application/json-rpc' -d '{"jsonrpc":"2.0","method":"host.get","id":"1","auth":"2dfa5af3d66b4ddde2e1ca0da9c16114","params":{}}' 'http://18.219.31.166/zabbix/api_jsonrpc.php'  | jq "."`
