unit UPessoa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit,
  FMX.DateTimeCtrls, Data.DBXFirebird, Data.DB, Data.SqlExpr, System.JSON, REST.Json,
  FMX.TabControl, FMX.ListBox, System.Actions, FMX.ActnList;

type
  TFrmPessoa = class(TForm)
    Layout1: TLayout;
    Text1: TText;
    Layout2: TLayout;
    Lt1Nome: TLayout;
    RoundRect5: TRoundRect;
    Layout5: TLayout;
    RoundRect8: TRoundRect;
    Label4: TLabel;
    Lt13CidadeUF: TLayout;
    RoundRect11: TRoundRect;
    editCidade: TEdit;
    RoundRect18: TRoundRect;
    editUF: TEdit;
    Lt11Bairro: TLayout;
    RoundRect12: TRoundRect;
    editBairro: TEdit;
    Lt12Endereco: TLayout;
    RoundRect13: TRoundRect;
    editEndereco: TEdit;
    Lt10CEPNum: TLayout;
    RoundRect14: TRoundRect;
    editCEP: TEdit;
    RoundRect17: TRoundRect;
    editNumero: TEdit;
    Lt3CPF: TLayout;
    RoundRect15: TRoundRect;
    editCPF: TEdit;
    Lt2Telefone: TLayout;
    RoundRect16: TRoundRect;
    editTelefone: TEdit;
    FramedVertScrollBox1: TFramedVertScrollBox;
    Lt4RG: TLayout;
    RoundRect1: TRoundRect;
    editRG: TEdit;
    Lt5DtNascimento: TLayout;
    RoundRect2: TRoundRect;
    deditNascimento: TDateEdit;
    lbNascimento: TLabel;
    Lt6TipoPessoa: TLayout;
    RoundRect3: TRoundRect;
    editTipoPessoa: TEdit;
    Lt8Situacao: TLayout;
    RoundRect4: TRoundRect;
    editSituacao: TEdit;
    Lt7Familia: TLayout;
    RoundRect6: TRoundRect;
    editFamilia: TEdit;
    Lt9Observacao: TLayout;
    RoundRect7: TRoundRect;
    editObservacao: TEdit;
    Lt14Complemento: TLayout;
    RoundRect19: TRoundRect;
    editComplemento: TEdit;
    StyleBook1: TStyleBook;
    editNome: TEdit;
    Rectangle1: TRectangle;
    TabControl1: TTabControl;
    tabPessoa: TTabItem;
    tabFamilia: TTabItem;
    Layout3: TLayout;
    Rectangle2: TRectangle;
    Text2: TText;
    Layout4: TLayout;
    RoundRect9: TRoundRect;
    Layout6: TLayout;
    RoundRect10: TRoundRect;
    editDescFamilia: TEdit;
    Layout7: TLayout;
    RoundRect20: TRoundRect;
    Label1: TLabel;
    comboSituacao: TComboBox;
    Text3: TText;
    RoundRect21: TRoundRect;
    Label2: TLabel;
    ActionList1: TActionList;
    actPessoa: TChangeTabAction;
    actFamilia: TChangeTabAction;
    RoundRect22: TRoundRect;
    Label3: TLabel;
    procedure RoundRect8Click(Sender: TObject);
    procedure editCEPExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RoundRect21Click(Sender: TObject);
    procedure RoundRect22Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RoundRect20Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPessoa: TFrmPessoa;

implementation

{$R *.fmx}
uses
  uFuncoes, uLogin, uPrincipal;

procedure TFrmPessoa.editCEPExit(Sender: TObject);
var
  json :TJsonObject;
begin
  try
    try
      frmLogin.RestClient1.BaseURL := 'viacep.com.br/ws/' + editCEP.text + '/json/';
      frmLogin.RestRequest1.Execute;

      json := TJsonObject.Create;
      json := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(frmLogin.RestRequest1.Response.JSONText),0) as TJSONObject;

      if pos('erro',json.ToString) <> 0 then      //'{"erro":true}'
      begin
        editCEP.text := '';
        editCEP.TextPrompt := 'CEP ñ encontrado';
        editEndereco.Text := '';
        editBairro.Text := '';
        editCidade.Text := '';
        editUF.Text := '';
      end
      else
      begin
        editEndereco.Text := upperCase(json.getValue<String>('logradouro'));
        editBairro.Text := upperCase(json.getValue<String>('bairro'));
        editCidade.Text := upperCase(json.getValue<String>('localidade'));
        editUF.Text := upperCase(json.getValue<String>('uf'));
      end;
    except
      showMessage('Erro ao consultar CEP.');
    end;

  finally
    json.Free;
  end;
end;

procedure TFrmPessoa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Assigned(frmPrincipal) then
  begin
    Application.CreateForm(TfrmPrincipal, FrmPrincipal);
  end;
  Application.MainForm := frmPrincipal;
  frmPrincipal.Show;
end;

procedure TFrmPessoa.FormShow(Sender: TObject);
begin
  actPessoa.Execute;
end;

procedure TFrmPessoa.RoundRect20Click(Sender: TObject);
begin
  try
    try
      if editDescFamilia.Text = '' then
      begin
        editDescFamilia.TextPrompt := 'Descrição obrigatória';
        exit;
      end;
      showMessage('Família id: ' +
      IntToStr(inserirfamilia(UpperCase(editDescFamilia.Text), comboSituacao.Items[comboSituacao.ItemIndex], frmLogIn.SqlConn)) +
      ' inserida com sucesso.');
    except
      showMessage('Erro ao inserir Família.');
    end;
  finally

  end;
end;

procedure TFrmPessoa.RoundRect21Click(Sender: TObject);
begin
  actFamilia.Execute;
end;

procedure TFrmPessoa.RoundRect22Click(Sender: TObject);
begin
  actPessoa.Execute;
end;

procedure TFrmPessoa.RoundRect8Click(Sender: TObject);
var
  validacao, idTelefone, idEndereco, idPessoa : Integer;
  QCadastro : TSQLQuery;
begin
  try
    try

      validacao := 1;

      if editNome.Text = '' then
      begin
        editNome.TextPrompt := 'Nome obrigatório';
        editNome.FontColor := TAlphaColors.Red;
        validacao := 0;
      end;
      if editCPF.Text = '' then
      begin
        editCPF.TextPrompt := 'CPF/CNPJ obrigatório';
        editCPF.FontColor := TAlphaColors.Red;
        validacao := 0;
      end;

      if editCEP.Text = '' then
      begin

        //validacao := 0;
      end
      else
      begin
        if editNumero.Text = '' then
        begin
          editNumero.TextPrompt := 'Número obrigatório';
          editNumero.FontColor := TAlphaColors.Red;
          validacao := 0;
        end;
        if editEndereco.Text = '' then
        begin
          editEndereco.TextPrompt := 'Endereco obrigatório';
          editEndereco.FontColor := TAlphaColors.Red;
          validacao := 0;
        end;
        if editBairro.Text = '' then
        begin
          editBairro.TextPrompt := 'Bairro obrigatório';
          editBairro.FontColor := TAlphaColors.Red;
          validacao := 0;
        end;
        if editCidade.Text = '' then
        begin
          editCidade.TextPrompt := 'Cidade obrigatória';
          editCidade.FontColor := TAlphaColors.Red;
          validacao := 0;
        end;
        if editUF.Text = '' then
        begin
          editUF.TextPrompt := '?';
          editUF.FontColor := TAlphaColors.Red;
          validacao := 0;
        end;
      end;

      if validacao = 0 then
      begin
        ShowMessage('Campos obrigatórios não preenchidos');
        QCadastro.Free;
        exit;
      end;


      idTelefone := 0;
      idEndereco := 0;

      if editTelefone.Text <> '' then
      begin
        idTelefone := inserirtelefone(editTelefone.Text, 'Telefone cadastro', frmLogin.SQLConn);
      end;
      if editCEP.Text <> '' then
      begin
        idEndereco := inserirEndereco(upperCase(editEndereco.Text), editNumero.Text, upperCase(editBairro.Text), upperCase(editCidade.Text),
                                    upperCase(editUF.Text), '', editCEP.Text, frmLogin.SQLConn);
      end;




      idPessoa := inserirpessoa(editCPF.Text, '', upperCase(editNome.Text), 'F', 'Cadastro login', 'ATIVO', Now(), idTelefone,
                               idEndereco, 0, 1, 0, 0, 0, frmLogin.SQLConn);

      if idPessoa <> 0 then
      begin
        showMessage('Pessoa inserida com sucesso');
      end;


    except
      showMessage('Erro ao inserir pessoa');
    end;
  finally
    QCadastro.Free;
  end;
end;

end.
