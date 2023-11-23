unit UnitNecessidades;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  FMX.DateTimeCtrls;

type
  TForm_Tela_Necessidades = class(TForm)
    grupo_necessidades: TLayout;
    descricao_familia: TLayout;
    RoundRect_Familia: TRoundRect;
    label_nome_familia: TLabel;
    digite_nome_familia: TEdit;
    descricao_produto: TLayout;
    RoundRect_Descricao: TRoundRect;
    label_descricao_produto: TLabel;
    digite_descricao: TEdit;
    quantidade: TLayout;
    Grupo_Qtd: TRoundRect;
    image_adicionar: TImage;
    image_remover: TImage;
    Edit2: TEdit;
    Label_Qtd: TLabel;
    salvar: TLayout;
    RoundRect_Salvar: TRoundRect;
    Label_Salvar: TLabel;
    titulo_necessidades: TLayout;
    Rectangle_Titulo: TRectangle;
    Image_Voltar: TImage;
    titulo_tela_necessidades: TLabel;
    periodo: TLayout;
    RoundRect_Periodo: TRoundRect;
    DateEdit1: TDateEdit;
    Label1: TLabel;
    StyleBook1: TStyleBook;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Tela_Necessidades: TForm_Tela_Necessidades;

implementation

{$R *.fmx}
uses
  uPrincipal;

procedure TForm_Tela_Necessidades.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   if not Assigned(frmPrincipal) then
  begin
    Application.CreateForm(TfrmPrincipal, FrmPrincipal);
  end;
  Application.MainForm := frmPrincipal;
  frmPrincipal.Show;
end;

end.
