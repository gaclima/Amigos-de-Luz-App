program AppAmigosDeLuz;

uses
  System.StartUpCopy,
  FMX.Forms,
  ULogIn in 'ULogIn.pas' {frmLogIn},
  uFuncoes in 'uFuncoes.pas',
  UPrincipal in 'UPrincipal.pas' {frmPrincipal},
  UPessoa in 'UPessoa.pas' {FrmPessoa},
  UnitCadastrarProduto in 'UnitCadastrarProduto.pas' {FormCadastrarProdutos},
  UnitNecessidades in 'UnitNecessidades.pas' {Form_Tela_Necessidades},
  UnitSeparacaoProdutos in 'UnitSeparacaoProdutos.pas' {Form_Tela_Separacao_Produtos};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLogIn, frmLogIn);
  Application.CreateForm(TFormCadastrarProdutos, FormCadastrarProdutos);
  Application.CreateForm(TForm_Tela_Necessidades, Form_Tela_Necessidades);
  Application.CreateForm(TForm_Tela_Separacao_Produtos, Form_Tela_Separacao_Produtos);
  Application.Run;
end.
