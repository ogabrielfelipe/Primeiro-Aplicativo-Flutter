import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:trabalho_1_a1/Controller/DatabaseHelper.dart';
import 'package:trabalho_1_a1/Model/Atendimento.dart';
import '../Controller/DatabaseHelper.dart';
import './home.dart';

class CadastroAtendimento extends StatelessWidget{
  CadastroAtendimento({Key? key}) : super(key: key);
  
  final tema = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 23, 16, 16),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white
      )
    ),
    scaffoldBackgroundColor: Color.fromARGB(255, 23, 16, 16),
    textTheme: const TextTheme(
      headline4: TextStyle(
        color: Colors.white,
        fontStyle: FontStyle.normal,
        fontSize: 20,
        fontFamily: 'Roboto',        
      ),
      bodyText1: TextStyle(
        color: Colors.white,
        fontStyle: FontStyle.normal,
        fontSize: 24,
        fontFamily: 'Roboto', 
      )
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 66, 63, 62),
      foregroundColor: Colors.white,
      elevation: 10,
    )
  );
  
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: tema,      
      home: MyCadastroAtendimento(atendimentoId: '',),
    );
  }
}


class MyCadastroAtendimento extends StatefulWidget{
  MyCadastroAtendimento({super.key, required this.atendimentoId});
  
  //final String title;
  
  String atendimentoId;


  @override
  MyCadastroAtendimentoState createState() {
    return MyCadastroAtendimentoState();
  }

}

class MyCadastroAtendimentoState extends State<MyCadastroAtendimento>{
  final _formKey = GlobalKey<FormState>();

  late DateTime dt1;
  late DatabaseHelper dbHelper;
  late Atendimento _atendimento;
  late Atendimento _atendimentoBusca;

  bool isEditing = false;

  final dateControllerAbertura = TextEditingController();
  final dateControllerEncerramento = TextEditingController();
  final solicitanteController = TextEditingController();
  final solicitacaoController = TextEditingController();
  final dropdownController = TextEditingController();
  String _valorDropDown = 'Em Atendimento';
  

  @override
  void initState(){
    super.initState();
    this.dbHelper = DatabaseHelper();
    this.dbHelper.initDb().whenComplete(() async{
      setState(() {});
    });

    if (widget.atendimentoId != ''){
      int id = int.parse(widget.atendimentoId);
      this.dbHelper.atenimento_id(id).then((value) => {
        setState(() {
          isEditing = true;
          _atendimentoBusca = value as Atendimento;
          dateControllerAbertura.text = _atendimentoBusca.DATA_ABERTURA;
          dateControllerEncerramento.text = _atendimentoBusca.DATA_ENCERRAMENTO;
          solicitanteController.text = _atendimentoBusca.NOME_SOLICITANTE;
          solicitacaoController.text = _atendimentoBusca.SOLICITACAO;
          _valorDropDown = _atendimentoBusca.STATUS_ATENDIMENTO;

        })
      });
    }
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateControllerAbertura.dispose();
    dateControllerEncerramento.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print(widget.atendimentoId);
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Atendimentos'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  readOnly: true,
                  controller: dateControllerAbertura,
                  decoration: const InputDecoration(
                    hintText: 'Data do Atendimento',
                    hintStyle: TextStyle(
                      color: Colors.white
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(100, 66, 63, 62),
                  ),
                  onTap: () async {
                    var date = await showDatePicker(
                      context: context, 
                      initialDate: DateTime.now(), 
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                      dateControllerAbertura.text = date.toString().substring(0,10);
                  }, 
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),                 
                )
              ),
               Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  controller: solicitanteController,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white
                      ),
                    ),
                    hintText: "Nome Solicitante",
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color.fromARGB(100, 66, 63, 62),
                    labelStyle: TextStyle(color: Colors.white)                  
                  ),                  
                )
               ),
               Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  controller: solicitacaoController,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  minLines: null,
                  maxLength: null,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white
                      ),
                    ),
                    hintText: "Solicitação",
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color.fromARGB(100, 66, 63, 62),
                    labelStyle: TextStyle(color: Colors.white)                  
                  ),                  
                )
               ),
               Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  readOnly: true,
                  controller: dateControllerEncerramento,
                  decoration: const InputDecoration(
                    hintText: 'Data de Encerramento',
                    hintStyle: TextStyle(
                      color: Colors.white
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(100, 66, 63, 62),
                  ),
                  onTap: () async {
                    var date = await showDatePicker(
                      context: context, 
                      initialDate: DateTime.now(), 
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                      dateControllerEncerramento.text = date.toString().substring(0,10);
                  },
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),                 
                )
              ),
               Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: DropdownButton<String>(
                  
                  value: _valorDropDown, 
                  style: const TextStyle(
                    color: Colors.white
                  ),
                  dropdownColor: Color.fromARGB(255, 87, 83, 81),
                  hint: const Text(
                    "Status Atendimento",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18
                      ),                                          
                    ),
                  onChanged: (String? value){
                    setState((){
                      _valorDropDown = value!;
                    });
                  },
                  items: <String>[
                    'Em Atendimento', 
                    'Em Desenvolvimento', 
                    'Finalizado',
                    ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ) 
               ),
               Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 110, 106, 103),
                    onPrimary:Color.fromARGB(255, 255, 255, 255),                    
                  ),
                  onPressed: () {
                    if(_formKey.currentState!.validate()){

                      _formKey.currentState!.save();
                      
                      var retorno =  addOrEditAtendimento();
                      retorno.then((value) {
                        if(value == 1){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Sucesso!'),
                              content: const Text('Salvo com sucesso'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => {chamaTela(context, HomePage())},
                                  child: const Text('OK'),
                                )
                              ],
                            )
                          );
                        }else{
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Sucesso!'),
                              content: const Text('Não foi possível salvar'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                )
                              ],
                            )
                          );
                        }

                      });
                      
                    }
                  },
                  child: const Text('Salvar'),
                )
              ), 
            ],
          ),
        ),
      ),
    );
  }

  Future<int> addOrEditAtendimento() async{
    String solicitante = solicitanteController.text;
    String solicitacao = solicitacaoController.text;
    String dataAbertura = dateControllerAbertura.text;
    String dataEncerramento = dateControllerEncerramento.text;
    String status = _valorDropDown;

    if(!isEditing){
      Atendimento atendimento = Atendimento(DATA_ABERTURA: dataAbertura, NOME_SOLICITANTE: solicitante,
        SOLICITACAO: solicitacao, DATA_ENCERRAMENTO: dataEncerramento, STATUS_ATENDIMENTO: status);
      
      var retorno = addAtendimento(atendimento);
      
      if (retorno != null){
        return 1;
      }else{
        return 0;
      }
    }else{
      _atendimentoBusca.DATA_ABERTURA = dataAbertura;
      _atendimentoBusca.NOME_SOLICITANTE = solicitante;
      _atendimentoBusca.SOLICITACAO = solicitacao;
      _atendimentoBusca.DATA_ENCERRAMENTO = dataEncerramento;
      _atendimentoBusca.STATUS_ATENDIMENTO = status;

      var retorno = update_atendimento(_atendimentoBusca);
      if (retorno != null){
        return 1;
      }else{
        return 0;
      }
    }
    resetData();
    setState(() {});
  }

  Future<int> addAtendimento(Atendimento a) async {
    return await this.dbHelper.insert_atendimento(a);
  }

  Future<int> update_atendimento(Atendimento a) async {
    return await this.dbHelper.update_atendimento(a);
  }

  void resetData() {
    solicitanteController.clear();
    solicitacaoController.clear();
    dateControllerAbertura.clear();
    dateControllerEncerramento.clear();
    _valorDropDown = 'Em Atendimento';
  }

}

void chamaTela(BuildContext context, StatelessWidget rota){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => rota)
  );
}