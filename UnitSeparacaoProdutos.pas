unit UnitSeparacaoProdutos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.DateTimeCtrls, FMX.Edit;

type
  TForm_Tela_Separacao_Produtos = class(TForm)
    Titulo_Tela: TLayout;
    Rectangle_Titulo: TRectangle;
    Image_Voltar: TImage;
    Label_Titulo: TLabel;
    Listagem: TRectangle;
    listagem_produtos: TListView;
    img_produto: TImage;
    Calendario: TLayout;
    DateEdit1: TDateEdit;
    Nome_Familia: TLayout;
    Rectangle2: TRectangle;
    Edit1: TEdit;
    Label1: TLabel;
    StyleBook1: TStyleBook;
    RoundRect1: TRoundRect;
    Gravar_Pedido: TLayout;
    RoundRect_Gravar_Pedido: TRoundRect;
    Label_Gravar_Pedido: TLabel;

    procedure FormShow(Sender: TObject);
    procedure listagem_produtosUpdatingObjects(const Sender: TObject;
      const AItem: TListViewItem; var AHandled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure AddProdutos(id_produto, descricao_produto, situacao: string;
      estoque: integer; foto: TStream);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Tela_Separacao_Produtos: TForm_Tela_Separacao_Produtos;

implementation

{$R *.fmx}
uses
  uPrincipal;

procedure TForm_Tela_Separacao_Produtos.AddProdutos(id_produto, descricao_produto,
                                                    situacao: string;
                                                    estoque: integer;
                                                    foto: TStream);
var
    txt : TListItemText;
    img : TListItemImage;
    bmp : TBitmap;
begin
     // Adicione uma verificação de nulo para evitar Access Violation
     if (listagem_produtos = nil) or (listagem_produtos.Items = nil) then
       Exit;

     with listagem_produtos.Items.Add do
     begin
           // Adicione uma verificação de nulo para evitar Access Violation
           if Objects = nil then
             Exit;

           txt := TListItemText(Objects.FindDrawable('NomeProduto'));
           if txt <> nil then
             txt.Text := descricao_produto
           else
             Exit;

           // Adicione uma verificação de nulo para evitar Access Violation
           if Objects.FindDrawable('Valor') <> nil then
             TListItemText(Objects.FindDrawable('Valor')).Text := Format('%d', [estoque])
           else
             Exit;

           // Imagem do produto
           img := TListItemImage(Objects.FindDrawable('FotoProduto'));

           if (img <> nil) and (foto <> nil) then
           begin
                  bmp := TBitmap.Create;
                  try
                    bmp.LoadFromStream(foto);
                    img.OwnsBitmap := true;
                    img.Bitmap := bmp;
                  except
                    bmp.Free;
                    raise;
                  end;
           end;
     end;
end;

procedure TForm_Tela_Separacao_Produtos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   if not Assigned(frmPrincipal) then
  begin
    Application.CreateForm(TfrmPrincipal, FrmPrincipal);
  end;
  Application.MainForm := frmPrincipal;
  frmPrincipal.Show;
end;

procedure TForm_Tela_Separacao_Produtos.FormShow(Sender: TObject);
var
  foto : TStream;
  x : integer;
begin
  for x := 1 to 10 do
  begin
    foto := TMemoryStream.Create;
    try
      img_produto.Bitmap.SaveToStream(foto);
      foto.Position := 0;
      AddProdutos('00001', 'Nome Produto', '', 1, foto);
    finally
      foto.Free;
    end;
  end;
end;

procedure TForm_Tela_Separacao_Produtos.listagem_produtosUpdatingObjects(
  const Sender: TObject; const AItem: TListViewItem; var AHandled: Boolean);
var
    txt : TListItemText;
begin
      // Adicione uma verificação de nulo para evitar Access Violation
      if (AItem = nil) or (AItem.Objects = nil) then
        Exit;

      txt := TListItemText(AItem.Objects.FindDrawable('NomeProduto'));
      if txt <> nil then
//        txt.Width := AItem.Width - txt.PlaceOffset.X - 100;
end;

end.
