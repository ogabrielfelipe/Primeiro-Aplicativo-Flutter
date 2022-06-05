import 'package:flutter/material.dart';
import '../Controller/DatabaseHelper.dart';
import 'package:trabalho_1_a1/Model/Atendimento.dart';
import './cadastro_atendimentos.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final tema = ThemeData(    
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 23, 16, 16),
      titleTextStyle: TextStyle(
        fontSize: 20,
        //fontWeight: FontWeight.bold,
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



 // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: tema,      
      home: const MyHomePage(title: 'Atendimentos',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  
  final String title;
  
  @override
  MyHomePageState createState() {
    return MyHomePageState();
  }
}


class MyHomePageState extends State<MyHomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  late Atendimento _atendimento;
  late var initialPosition;

  List<Atendimento> _atendimentoList = [];

  //final ScrollController _firstController = ScrollController();
  

  @override
  void initState() {
    super.initState();
    _dbHelper.retrieve_atendimentos().then((list) {
      setState(() {
        _atendimentoList = list;
      });
    });
  }

  
  Map<int, bool> selectedFlag = {};
  bool isSelectionMode = false;


  static final AppBar _appBarDefault = AppBar(
    title:const Text(
      'Atendimentos', 
      style: TextStyle(
        color: Colors.white
        ),
    ),
    centerTitle: true,
  );

  AppBar _appBar = _appBarDefault;


  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: _appBar,
      body: LayoutBuilder(
        builder: ((context, constraints) => Row(
          children: <Widget> [
            SizedBox(
              width: constraints.maxWidth,
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: _atendimentoList.length,
                  key: UniqueKey(),
                  itemBuilder: (BuildContext context, int index){                    

                  selectedFlag[index] = selectedFlag[index] ?? false;  
                  bool isSelected = selectedFlag[index] ?? false;

                    return ListTile(
                      onLongPress: () => onLongPress(isSelected, index, _atendimentoList[index]),
                      onTap: () => onTap(isSelected, index),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _atendimentoList[index].NOME_SOLICITANTE,
                            style: const TextStyle(
                              color: Colors.white
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                _atendimentoList[index].DATA_ABERTURA,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0
                                ),
                              ),
                              const Text(' - ', style: TextStyle(color: Colors.white),),
                              Text(
                                _atendimentoList[index].STATUS_ATENDIMENTO,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0
                                ),
                              )

                            ],  
                          )
                        ],
                      ),
                      subtitle: Text(
                        _atendimentoList[index].SOLICITACAO,
                        style: const TextStyle(
                          color: Colors.white
                        ),

                      ),
                      leading: _buildSelectIcon(isSelected, _atendimentoList[index]),
                    );
                    
                  },
                ),
              ),
            )
          ],
        )
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          chamaTela(context, CadastroAtendimento());
        },
        child: const Icon(Icons.add),
      ),

    );
  }
  

  void onLongPress (bool isSelected, int index, Atendimento atendimento){
    setState(() {
      
      _appBar = _appBar == _appBarDefault
        ? _appBarSelected(isSelected, index, atendimento)
        : _appBarDefault;

      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }
  void onTap (bool isSelected, int index){
    if (isSelectionMode){
      setState(() {

        _appBar =_appBarDefault;


        selectedFlag[index] = !isSelected;
        isSelectionMode = selectedFlag.containsValue(true);
      });
    }
  }

  Widget _buildSelectIcon(bool isSelected, Atendimento atendimento){
    if(isSelectionMode){
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: Theme.of(context).primaryColor,
      );
    }else{
      return CircleAvatar (
        child: Text(
          atendimento.ID.toString(),
          style: TextStyle(
            color: Colors.white
          ),
        ),
      );
    }
  }

  Widget _buildSelectionItem(bool isSelected, Atendimento atendimento){
    if(isSelectionMode){
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: Theme.of(context).primaryColor,
      );
    }else{
      return const Text (
        'Atendimentos',
        style: TextStyle(
          color: Colors.white
        ),
      );
    }
  }



  AppBar _appBarSelected (bool isSelected, int index, Atendimento atendimento){
    return AppBar(
      title: Text (
        "Atendimento: ${atendimento.ID}",
        style: const TextStyle(
          color: Colors.white
        ),
      ),
      leading: TextButton(
          onPressed: () => {
            if(isSelectionMode){
              setState(() {
                print(isSelected.toString()+ " - " + index.toString());
                selectedFlag[index] = !isSelected;
                isSelectionMode = selectedFlag.containsValue(true);
              })
            }
          },
          child: const Icon(
            Icons.close,
            color: Colors.white
            ),
        ), 
      actions: <Widget>[
        TextButton(
          onPressed: () => {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyCadastroAtendimento(
                    atendimentoId: atendimento.ID.toString(),
                    ))
                );
            })


          },
          child: const Icon(
            Icons.edit_note_outlined,
            color: Colors.white
            ),
        ),
        TextButton(
          onPressed: () => {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Confirmação'),
                content: Text('Tem certeza que deseja excluir o atendimento: ${atendimento.ID.toString()}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {
                      setState(() {
                        Navigator.pop(context, 'OK');
                      })
                    },
                    child: const Text('Não, Não desejo!')
                  ),
                  TextButton(
                    onPressed: () => {
                      if (atendimento.ID != null){
                        setState(() {
                          //Exclui o atendimento Selecionado
                          _dbHelper.delete_atendimento(atendimento.ID!);  

                          //volta ao appBar Padrão
                          _appBar =_appBarDefault;                   
                          
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage()
                            )
                          );
                        })                           
                      }                      
                    },
                    child: const Text('Sim, Desejo Excluir!'),
                  )                  
                ],
              )
            )
          },
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            ),
        ),        
      ],
    );
  }

}

void chamaTela(BuildContext context, StatelessWidget rota){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => rota)
  );
}