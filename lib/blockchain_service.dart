import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart'; // For making RPC requests

class BlockchainService {
  final String rpcUrl =
      "https://mainnet.infura.io/v3/31c305b9d45e46488bb06cdfca091424"; // Update with actual RPC URL
  final String privateKey =
      "0x0a57C15466b81BA4684732b0E5A68DaEE6c3e204"; // Securely store this
  final String contractAddress =
      "31c305b9d45e46488bb06cdfca091424"; // Deployed contract address

  late Web3Client _client;
  late Credentials _credentials;
  late DeployedContract _contract;
  late ContractFunction _storeDataFunction;
  late ContractEvent _dataStoredEvent;

  BlockchainService() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _client = Web3Client(rpcUrl, Client());

      _credentials = EthPrivateKey.fromHex(privateKey);

      final abiCode = await _loadAbi();
      _contract = DeployedContract(
        ContractAbi.fromJson(abiCode, "EduChain"),
        EthereumAddress.fromHex(contractAddress),
      );

      _storeDataFunction = _contract.function("storeSensorData");
      _dataStoredEvent = _contract.event("DataStored");

      print("Blockchain Service Initialized!");
    } catch (e) {
      print("Error initializing blockchain service: $e");
    }
  }

  Future<String> _loadAbi() async {
    // Replace with the actual ABI JSON content or fetch from a file
    return '''
    [
      {"constant":false,"inputs":[{"name":"temperature","type":"uint256"},{"name":"humidity","type":"uint256"},{"name":"moisture","type":"uint256"}],"name":"storeSensorData","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},
      {"anonymous":false,"inputs":[{"indexed":false,"name":"temperature","type":"uint256"},{"indexed":false,"name":"humidity","type":"uint256"},{"indexed":false,"name":"moisture","type":"uint256"}],"name":"DataStored","type":"event"}
    ]
    ''';
  }

  Future<void> storeSensorData(
    BigInt temperature,
    BigInt humidity,
    BigInt moisture,
  ) async {
    try {
      final transaction = Transaction.callContract(
        contract: _contract,
        function: _storeDataFunction,
        parameters: [temperature, humidity, moisture],
        from: await _credentials.extractAddress(),
      );

      final txHash = await _client.sendTransaction(
        _credentials,
        transaction,
        chainId: 11155111, // Sepolia Testnet Chain ID (Update if needed)
      );

      print("Transaction sent! Hash: $txHash");
    } catch (e) {
      print("Error sending transaction: $e");
    }
  }

  void listenForDataStoredEvents() {
    final filter = _client.events(
      FilterOptions.events(contract: _contract, event: _dataStoredEvent),
    );

    filter.listen((event) {
      final decoded = _dataStoredEvent.decodeResults(
        event.topics!,
        event.data!,
      );
      final BigInt temperature = decoded[0] as BigInt;
      final BigInt humidity = decoded[1] as BigInt;
      final BigInt moisture = decoded[2] as BigInt;

      print(
        "Blockchain Event Received: Temperature=$temperature, Humidity=$humidity, Moisture=$moisture",
      );
    });
  }
}
