unit UnitCadastrarProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.TabControl,
  System.Actions, FMX.ActnList, FMX.Edit, Data.DBXFirebird, Data.DB, Data.SqlExpr;

type
  TFormCadastrarProdutos = class(TForm)
    Categorias: TLayout;
    cesta_basica: TLayout;
    higiene_pessoal: TLayout;
    produtos_de_limpeza: TLayout;
    roupas_calcados: TLayout;
    Rectangle_Cesta_Basica: TRectangle;
    Rectangle_higiene_pessoal: TRectangle;
    Rectangle_produtos_limpeza: TRectangle;
    Rectangle_roupas: TRectangle;
    Label_cesta_basica: TLabel;
    Label_higiene_pessoal: TLabel;
    Label_produtos_limpeza: TLabel;
    Label_roupas_calcados: TLabel;
    Image_cesta_basica: TImage;
    Image_higiene_pessoal: TImage;
    Image_produtos_limpeza: TImage;
    Image_roupas: TImage;
    TabControl1: TTabControl;
    Tab_Tela_Cadastrar_Produtos: TTabItem;
    Layout_Titulo: TLayout;
    Rectangle5: TRectangle;
    titulo_tela: TLabel;
    voltar: TImage;
    Tab_Registrar_Produtos: TTabItem;
    titulo: TLayout;
    Rectangle_Titulo: TRectangle;
    Label_Titulo: TLabel;
    grupo_descricao: TLayout;
    descricao: TLayout;
    categoria: TLayout;
    RoundRect_Descricao: TRoundRect;
    RoundRect_Categoria: TRoundRect;
    Label_Categoria: TLabel;
    Label_Descricao: TLabel;
    quantidade: TLayout;
    Label_Qtd: TLabel;
    Layout_Finalizacao: TLayout;
    RoundRect_Alterar: TRoundRect;
    Label_Alterar: TLabel;
    RoundRect_Salvar: TRoundRect;
    Label_Salvar: TLabel;
    editDescProduto: TEdit;
    StyleBook1: TStyleBook;
    image_adicionar: TImage;
    image_remover: TImage;
    Grupo_Qtd: TRoundRect;
    editCategoria: TEdit;
    RoundRect_Selecione: TRoundRect;
    seta_baixo: TImage;
    ActionList1: TActionList;
    ActCadastrar_Produto: TChangeTabAction;
    Image_Voltar: TImage;
    ActDadosProduto: TChangeTabAction;
    editQtde: TEdit;
    procedure Image_VoltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Rectangle_Cesta_BasicaClick(Sender: TObject);
    procedure Rectangle_higiene_pessoalClick(Sender: TObject);
    procedure Rectangle_produtos_limpezaClick(Sender: TObject);
    procedure Rectangle_roupasClick(Sender: TObject);
    procedure image_adicionarClick(Sender: TObject);
    procedure image_removerClick(Sender: TObject);
    procedure RoundRect_SalvarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCadastrarProdutos: TFormCadastrarProdutos;
  id_categoria : Integer;

implementation

{$R *.fmx}

uses
  ulogIn, uFuncoes, uPrincipal;

procedure TFormCadastrarProdutos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not Assigned(frmPrincipal) then
  begin
    Application.CreateForm(TfrmPrincipal, FrmPrincipal);
  end;
  Application.MainForm := frmPrincipal;
  frmPrincipal.Show;
end;

procedure TFormCadastrarProdutos.FormShow(Sender: TObject);
begin
  ActDadosProduto.Execute;
end;

procedure TFormCadastrarProdutos.image_adicionarClick(Sender: TObject);
begin
  editQtde.text := IntToStr(StrToInt(editQtde.text) + 1);
end;

procedure TFormCadastrarProdutos.image_removerClick(Sender: TObject);
begin
  if StrToInt(editQtde.text) > 0 then
  begin
    editQtde.text := IntToStr(StrToInt(editQtde.text) - 1);
  end;
end;

procedure TFormCadastrarProdutos.Image_VoltarClick(Sender: TObject);
begin
  ActDadosProduto.Execute;
end;

procedure TFormCadastrarProdutos.Rectangle_Cesta_BasicaClick(Sender: TObject);
begin
  editCategoria.Text := 'CESTA BASICA';
  editCategoria.Enabled := False;
  id_categoria := 2;
  ActCadastrar_Produto.Execute;
end;

procedure TFormCadastrarProdutos.Rectangle_higiene_pessoalClick(
  Sender: TObject);
begin
  editCategoria.Text := 'HIGIENE PESSOAL';
  editCategoria.Enabled := False;
  id_categoria := 3;
  ActCadastrar_Produto.Execute;
end;

procedure TFormCadastrarProdutos.Rectangle_produtos_limpezaClick(
  Sender: TObject);
begin
  editCategoria.Text := 'PRODUTOS DE LIMPEZA';
  editCategoria.Enabled := False;
  id_categoria := 4;
  ActCadastrar_Produto.Execute;
end;

procedure TFormCadastrarProdutos.Rectangle_roupasClick(Sender: TObject);
begin
  editCategoria.Text := 'ROUPAS E CALCADOS';
  editCategoria.Enabled := False;
  id_categoria := 5;
  ActCadastrar_Produto.Execute;
end;

procedure TFormCadastrarProdutos.RoundRect_SalvarClick(Sender: TObject);
var
  QInsere: TSQLQuery;
begin
  try
    try
      QInsere := TSQLQuery.Create(nil);
      QInsere.SQLConnection := frmLogIn.SQLConn;

      if editDescProduto.Text = '' then
      begin
        editDescProduto.TextPrompt := 'Campo Obrigatório';
        Exit;
      end;

      showMessage('Produto id: ' +
      IntToStr(inserirProduto(uppercase(editDescProduto.Text), 'ATIVO', StrToCurr(editQtde.Text), id_categoria, frmLogIn.SQLConn)) +
       ' cadastrado.');
    except
      showMessage('Erro ao cadastrar produto');
    end;
  finally
    QInsere.Free;
  end;
end;

end.
