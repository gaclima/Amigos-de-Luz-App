unit UPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, System.Math.Vectors, FMX.Controls3D,
  FMX.Objects3D, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmPrincipal = class(TForm)
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    Text1: TText;
    Text2: TText;
    Text3: TText;
    Text4: TText;
    Layout5: TLayout;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout6: TLayout;
    Text5: TText;
    ListView1: TListView;
    Text6: TText;
    ProgressBar1: TProgressBar;
    Layout7: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    Layout8: TLayout;
    ProgressBar2: TProgressBar;
    Label3: TLabel;
    Label4: TLabel;
    Layout9: TLayout;
    ProgressBar3: TProgressBar;
    Label5: TLabel;
    Label6: TLabel;
    Layout10: TLayout;
    ProgressBar4: TProgressBar;
    Label7: TLabel;
    Label8: TLabel;
    procedure Text1Click(Sender: TObject);
    procedure Text2Click(Sender: TObject);
    procedure Text3Click(Sender: TObject);
    procedure Text4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

uses uFuncoes, uPessoa, UnitCadastrarProduto, UnitSeparacaoProdutos, UnitNecessidades;

procedure TfrmPrincipal.Text1Click(Sender: TObject);
begin
  // abrir tela cadastro familia
  if not Assigned(FrmPessoa) then
  begin
    Application.CreateForm(TFrmPessoa, FrmPessoa);
  end;
  Application.MainForm := FrmPessoa;
  FrmPessoa.Show;
  //FrmPrincipal.Close;
end;

procedure TfrmPrincipal.Text2Click(Sender: TObject);
begin
  // abrir tela cadastro produtos
  if not Assigned(FormCadastrarProdutos) then
  begin
    Application.CreateForm(TFormCadastrarProdutos, FormCadastrarProdutos);
  end;
  Application.MainForm := FormCadastrarProdutos;
  FormCadastrarProdutos.Show;
  //FrmPrincipal.Close;
end;

procedure TfrmPrincipal.Text3Click(Sender: TObject);
begin
  // abrir tela separação
  if not Assigned(Form_Tela_Separacao_Produtos) then
  begin
    Application.CreateForm(TForm_Tela_Separacao_Produtos, Form_Tela_Separacao_Produtos);
  end;
  Application.MainForm := Form_Tela_Separacao_Produtos;
  Form_Tela_Separacao_Produtos.Show;
end;

procedure TfrmPrincipal.Text4Click(Sender: TObject);
begin
  //abrir tela necessidades
  if not Assigned(Form_Tela_Necessidades) then
  begin
    Application.CreateForm(TForm_Tela_Necessidades, Form_Tela_Necessidades);
  end;
  Application.MainForm := Form_Tela_Necessidades;
  Form_Tela_Necessidades.Show;
end;

end.
