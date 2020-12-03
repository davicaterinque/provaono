import 'package:flutter/material.dart';


class Carro {

  String _modelo;
  double _ano;
  double _valor;
  double _comissao = 0.02;


  Carro(this._ano, this._valor, [this._modelo]) {
    this._comissao = calcularComissao();
  }


  double calcularComissao() {
    return _valor * 0.02;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Carro> lista = []; // Lista vazia

  // Construtor
  MyApp() {
    Carro carro1 = Carro(2012, 20000, "Crossfox");
    Carro carro2 = Carro(2020, 105000, "Civic");
    lista.add(carro1);
    lista.add(carro2);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Calcular comissão",
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(lista),
    );
  }
}

class HomePage extends StatefulWidget {
  final List<Carro> lista;


  HomePage(this.lista);

  @override
  _HomePageState createState() => _HomePageState(lista);
}

class _HomePageState extends State<HomePage> {
  final List<Carro> lista;


  _HomePageState(this.lista);


  void _atualizarTela() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: NavDrawer(lista),
      appBar: AppBar(
        title: Text("Carros (${lista.length})"),
      ),
      body: ListView.builder(
          itemCount: lista.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                "${lista[index]._modelo}",
                style: TextStyle(fontSize: 18.0),
              ),
              onTap: () {},
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _atualizarTela,
        tooltip: 'Atualizar',
        child: Icon(Icons.update),
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {

  final List lista;
  final double _fontSize = 17.0;


  NavDrawer(this.lista);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Opcional
          DrawerHeader(
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            decoration: BoxDecoration(color: Colors.orange),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text(
              "Informações do Carro",
              style: TextStyle(fontSize: _fontSize),
            ),
            onTap: () {
              Navigator.pop(context); // Fecha o Drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaInformacoesDoCarro(lista),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.car_repair),
            title: Text(
              "Buscar por um Carro",
              style: TextStyle(fontSize: _fontSize),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaBuscarPorCarro(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.car_rental),
            title: Text(
              "Cadastrar um Novo Carro",
              style: TextStyle(fontSize: _fontSize),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaCadastrarCarro(lista),
                ),
              );
            },
          ),
          Container(
            padding: EdgeInsets.all(20.0),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              leading: Icon(Icons.face),
              title: Text(
                "Sobre",
                style: TextStyle(fontSize: _fontSize),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaSobre(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class TelaInformacoesDoCarro extends StatefulWidget {
  final List<Carro> lista;

  // Construtor
  TelaInformacoesDoCarro(this.lista);

  @override
  _TelaInformacoesDoCarro createState() => _TelaInformacoesDoCarro(lista);
}

class _TelaInformacoesDoCarro extends State<TelaInformacoesDoCarro> {
  // Atributos
  final List lista;
  Carro carro;
  int index = -1;
  double _fontSize = 18.0;
  final modeloController = TextEditingController();
  final anoController = TextEditingController();
  final valorController = TextEditingController();
  final comissaoController = TextEditingController();
  bool _edicaoHabilitada = false;


  _TelaInformacoesDoCarro(this.lista) {
    if (lista.length > 0) {
      index = 0;
      carro = lista[0];
      modeloController.text = carro._modelo;
      anoController.text = carro._ano.toString();
      valorController.text = carro._valor.toString();
      comissaoController.text = carro._comissao.toStringAsFixed(1);
    }
  }


  void _exibirRegistro(index) {
    if (index >= 0 && index < lista.length) {
      this.index = index;
      carro = lista[index];
      modeloController.text = carro._modelo;
      anoController.text = carro._ano.toString();
      valorController.text = carro._valor.toString();
      comissaoController.text = carro._comissao.toStringAsFixed(1);
      setState(() {});
    }
  }

  void _atualizarDados() {
    if (index >= 0 && index < lista.length) {
      _edicaoHabilitada = false;
      lista[index]._modelo = modeloController.text;
      lista[index]._ano = double.parse(anoController.text);
      lista[index]._valor = double.parse(valorController.text);
      lista[index]._comissao = lista[index].calcularComissao();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var titulo = "Informações do Carro";
    if (carro == null) {
      return Scaffold(
        appBar: AppBar(title: Text(titulo)),
        body: Column(
          children: <Widget>[
            Text("Nenhum carro encontrado!"),
            Container(
              color: Colors.blueGrey,
              child: BackButton(),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  _edicaoHabilitada = true;
                  setState(() {});
                },
                tooltip: 'Primeiro',
                child: Text("Edit"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                enabled: _edicaoHabilitada,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Modelo",

                ),
                style: TextStyle(fontSize: _fontSize),
                controller: modeloController,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                enabled: _edicaoHabilitada,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Ano do Carro",

                ),
                style: TextStyle(fontSize: _fontSize),
                controller: anoController,
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 20),
              child: TextField(
                enabled: _edicaoHabilitada,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Valor do carro",
                  hintText: "Valor do carro",
                ),
                style: TextStyle(fontSize: _fontSize),
                controller: valorController,
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 20),
              child: TextField(
                enabled: false,

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Comissao",
                  hintText: "Comissao",
                ),
                style: TextStyle(fontSize: _fontSize),
                controller: comissaoController,
              ),
            ),
            RaisedButton(
              child: Text(
                "Atualizar Dados",

                style: TextStyle(fontSize: _fontSize),
              ),
              onPressed: _atualizarDados,
            ),
            Text(
              "[${index + 1}/${lista.length}]",
              style: TextStyle(fontSize: 15.0),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <FloatingActionButton>[
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () => _exibirRegistro(0),
                    tooltip: 'Primeiro',
                    child: Icon(Icons.first_page),
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () => _exibirRegistro(index - 1),
                    tooltip: 'Primeiro',
                    child: Icon(Icons.navigate_before),
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () => _exibirRegistro(index + 1),
                    tooltip: 'Primeiro',
                    child: Icon(Icons.navigate_next),
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () => _exibirRegistro(lista.length - 1),
                    tooltip: 'Primeiro',
                    child: Icon(Icons.last_page),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TelaSobre extends StatefulWidget {
  @override
  _TelaSobreState createState() => _TelaSobreState();
}

class _TelaSobreState extends State<TelaSobre> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sobre")),

      drawer: Drawer(),
      body: Center(
        child: Container(
          child: Text('Davi Caterinque RA: 190009586, APP para calcular comissão de vendedor de carros ', style: TextStyle(fontSize: 45),),
 
        ),
      ),
    );
  }
}

class TelaBuscarPorCarro extends StatefulWidget {
  @override
  _TelaBuscarPorCarroState createState() => _TelaBuscarPorCarroState();
}

class _TelaBuscarPorCarroState extends State<TelaBuscarPorCarro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buscar por Carro")),
    );
  }
}


class TelaCadastrarCarro extends StatefulWidget {
  final List<Carro> lista;


  TelaCadastrarCarro(this.lista);

  @override
  _TelaCadastrarCarroState createState() => _TelaCadastrarCarroState(lista);
}

class _TelaCadastrarCarroState extends State<TelaCadastrarCarro> {

  final List<Carro> lista;
  String _modelo = "";
  double _ano = 0.0;
  double _valor = 0.0;
  double _fontSize = 20.0;
  final modeloController = TextEditingController();
  final anoController = TextEditingController();
  final valorController = TextEditingController();
  final comissaoController = TextEditingController();


  _TelaCadastrarCarroState(this.lista);


  void _cadastrarCarro() {
    _modelo = modeloController.text;
    _ano = double.parse(anoController.text);
    _valor = double.parse(valorController.text);
    if (_ano > 0 && _valor > 0) {
      var carro = Carro(_ano, _valor, _modelo);

      lista.add(carro);

      modeloController.text = "";
      anoController.text = "";
      valorController.text = "";
      comissaoController.text = "${carro._comissao.toStringAsFixed(1)}";
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Carro"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(

          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                "Dados do Carro:",
                style: TextStyle(fontSize: _fontSize),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Modelo",

                ),
                style: TextStyle(fontSize: _fontSize),
                controller: modeloController,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Ano",

                ),
                style: TextStyle(fontSize: _fontSize),
                controller: anoController,
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 20),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Valor Reais",
                  hintText: "Valor Reais",
                ),
                style: TextStyle(fontSize: _fontSize),
                controller: valorController,
              ),
            ),


            RaisedButton(
              child: Text(
                "Cadastrar Carro",
                style: TextStyle(fontSize: _fontSize),
              ),
              onPressed: _cadastrarCarro,
            ),
          ],
        ),
      ),
    );
  }
}
