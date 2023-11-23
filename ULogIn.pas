unit ULogIn;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.TabControl,
  System.Actions, FMX.ActnList, Data.DBXFirebird, Data.DB, Data.SqlExpr,
  IPPeerClient, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.JSON, REST.Json;

type
  TfrmLogIn = class(TForm)
    Layout1: TLayout;
    imgLoginLogo: TImage;
    RoundRect1: TRoundRect;
    LayoutEmail: TLayout;
    edtLoginEmail: TEdit;
    StyleBook1: TStyleBook;
    LayoutSenha: TLayout;
    RoundRect2: TRoundRect;
    edtLoginSenha: TEdit;
    LayoutBotoes: TLayout;
    RoundRect3: TRoundRect;
    RoundRect4: TRoundRect;
    Label1: TLabel;
    Label2: TLabel;
    TabControl1: TTabControl;
    TabLogin: TTabItem;
    TabCadastro: TTabItem;
    Layout2: TLayout;
    Lt1Nome: TLayout;
    RoundRect5: TRoundRect;
    editNome: TEdit;
    Layout5: TLayout;
    RoundRect8: TRoundRect;
    Label4: TLabel;
    Lt9Senha: TLayout;
    RoundRect9: TRoundRect;
    editSenha: TEdit;
    Lt8Email: TLayout;
    RoundRect10: TRoundRect;
    editEmail: TEdit;
    Lt7CidadeUF: TLayout;
    RoundRect11: TRoundRect;
    editCidade: TEdit;
    Lt6Bairro: TLayout;
    RoundRect12: TRoundRect;
    editBairro: TEdit;
    Lt5Endereco: TLayout;
    RoundRect13: TRoundRect;
    editEndereco: TEdit;
    Lt4CEPNum: TLayout;
    RoundRect14: TRoundRect;
    editCEP: TEdit;
    Lt3CPF: TLayout;
    RoundRect15: TRoundRect;
    editCPF: TEdit;
    Lt2Telefone: TLayout;
    RoundRect16: TRoundRect;
    editTelefone: TEdit;
    FramedVertScrollBox1: TFramedVertScrollBox;
    RoundRect17: TRoundRect;
    editNumero: TEdit;
    RoundRect18: TRoundRect;
    editUF: TEdit;
    ActionList1: TActionList;
    Action1: TAction;
    ActLogin: TChangeTabAction;
    ActCadastro: TChangeTabAction;
    lblLoginVoltar: TLabel;
    SQLConn: TSQLConnection;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    procedure RoundRect4Click(Sender: TObject);
    procedure lblLoginVoltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RoundRect3Click(Sender: TObject);
    procedure RoundRect8Click(Sender: TObject);
    procedure editCEPExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogIn: TfrmLogIn;

implementation

{$R *.fmx}

uses uFuncoes, uPrincipal;

procedure TfrmLogIn.editCEPExit(Sender: TObject);
var
  json :TJsonObject;
begin
  try
    try
      RestClient1.BaseURL := 'viacep.com.br/ws/' + editCEP.text + '/json/';
      RestRequest1.Execute;

      json := TJsonObject.Create;
      json := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(RestRequest1.Response.JSONText),0) as TJSONObject;

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

procedure TfrmLogIn.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmLogin := nil;
end;

procedure TfrmLogIn.FormShow(Sender: TObject);
begin
  ActLogin.Execute;
end;

procedure TfrmLogIn.lblLoginVoltarClick(Sender: TObject);
begin
  ActLogin.Execute;
end;

procedure TfrmLogIn.RoundRect3Click(Sender: TObject);
var
  QCadastro : TSQLQuery;
begin
  try
    try
      QCadastro := TSQLQuery.Create(nil);
      QCadastro.SQLConnection := SQLConn;

      if edtLoginEmail.Text = '' then
      begin
        showMessage('Preencher e-mail.');
        Exit;
      end;
      if edtLoginSenha.Text = '' then
      begin
        ShowMessage('Preencher senha.');
        Exit;
      end;

      with QCadastro do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' select senha_login from login where email_login = :email_login ');
        ParamByName('email_login').AsString := upperCase(edtLoginEmail.Text);
        Open;
        if IsEmpty then
        begin
          ShowMessage('Usuário não cadastrado.');
          Exit;
        end;

        if FieldByName('senha_login').AsString <> criptoMD5(edtLoginSenha.Text) then
        begin
          ShowMessage('Senha incorreta');
          Exit;
        end;

        //Abrir tela inicial

        if not Assigned(frmPrincipal) then
        begin
          Application.CreateForm(TfrmPrincipal, FrmPrincipal);
        end;
        Application.MainForm := frmPrincipal;
        frmPrincipal.Show;
        //frmLogIn.Close

      end;
    Except
      ShowMessage('erro ao consultar usuário. ');
    end;
  finally
    QCadastro.Free;
  end;

end;

procedure TfrmLogIn.RoundRect4Click(Sender: TObject);
begin
  ActCadastro.Execute;
end;

procedure TfrmLogIn.RoundRect8Click(Sender: TObject);
var
  validacao, idTelefone, idEndereco, idPessoa : Integer;
  QLogin : TSQLQuery;
begin
  try
    try
      QLogin := TSQLQuery.Create(nil);
      QLogin.SQLConnection := SQLConn;

      validacao := 1;
      if editNome.Text = '' then
      begin
        editNome.TextPrompt := 'Nome obrigatório';
        editNome.FontColor := TAlphaColors.Red;
        validacao := 0;
      end;
      if editCPF.Text = '' then
      begin
        editCPF.TextPrompt := 'CPF obrigatório';
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
      if editEmail.Text = '' then
      begin
        editEmail.TextPrompt := 'Email obrigatório';
        editEmail.FontColor := TAlphaColors.Red;
        validacao := 0;
      end;
      if editSenha.Text = '' then
      begin
        editSenha.TextPrompt := 'Senha obrigatório';
        editSenha.FontColor := TAlphaColors.Red;
        validacao := 0;
      end;

      if validacao = 0 then
      begin
        ShowMessage('Campos obrigatórios não preenchidos');
        QLogin.Free;
        exit;
      end;


      if editTelefone.Text <> '' then
      begin
        idTelefone := inserirtelefone(editTelefone.Text, 'Telefone cadastro', SQLConn);
      end;

      if editCEP.Text <> '' then
      begin
        idEndereco := inserirEndereco(upperCase(editEndereco.Text), editNumero.Text, upperCase(editBairro.Text), upperCase(editCidade.Text),
                                    upperCase(editUF.Text), '', editCEP.Text, SQLConn);
      end;

      idPessoa := inserirpessoa(editCPF.Text, '', upperCase(editNome.Text), 'F', 'Cadastro login', 'ATIVO', Now(), idTelefone, idEndereco, 0, 1, 0, 0, 0, SQLConn);

      with QLogin do
      begin
        close;
        Sql.Clear;
        Sql.Add(' insert into login(email_login, senha_login, id_pessoa_login) values (:email_login, :senha_login, :id_pessoa_login) ');
        paramByName('email_login').AsString := upperCase(editEmail.Text);
        paramByName('senha_login').AsString := criptoMD5(editSenha.Text);
        paramByName('id_pessoa_login').AsInteger := idPessoa;
        ExecSql;
      end;

      ShowMessage('Cadastro realizado');
      ActLogin.Execute;

    except
      ShowMessage('Erro ao cadastrar login');
    end;
  finally
    QLogin.Free;
  end;
end;

end.
