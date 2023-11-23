unit uFuncoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.SqlExpr, Data.DB, iDHashMessageDigest;

function inserirtelefone(numeroTel, OBS : String; SQLConn : TSQLConnection) : Integer;
function retornaId(tabela, nomeId : String; SqlConn : TSQLConnection) : Integer;
function alterartelefone(numeroTel, OBS : String; id_telefone : Integer; SQLConn : TSQLConnection) : Boolean;
function excluirtelefone(id_telefone : Integer; SqlConn : TSQLConnection) : Boolean;
function inserirfamilia(descricao, situacao : String; SqlConn : TSQLConnection) : Integer;
function alterarfamilia(descricao : String; id_familia : Integer; SqlConn : TSQLConnection) : Boolean;
function inativarfamilia(id_familia: Integer; SqlConn : TSQLConnection) : Boolean;
function inserirpessoa(cnpj_cpf, rg_ie, razao, fisica_juridica, obs, situacao : String; dataNascimento : TDateTime; idTelefone, idEndereco, fornecedor, voluntario,
funcionario, beneficiario, doador : Integer; SqlConn : TSQLConnection) : Integer;
function criptoMD5(senha : String) : String;
function alterartipomovimentacao(id_tipo_movimentacao : Integer; descricao : String; SqlConn : TSQLConnection) : Boolean;
function inserirtipomovimentacao(descricao : String; SqlConn : TSQLConnection) : Integer;
function inserirCategoria(descricaoCategoria : String; SQLConn : TSQLConnection) : Integer;
function alterarCategoria(descricaoCategoria : String; idCategoria: Integer; SQLConn : TSQLConnection) : Boolean;
function excluirCategoria(idCategoria : Integer; SqlConn : TSQLConnection) : Boolean;
function inserirMembroFamilia(chefeFamilia : String; idFamiliaMembro, idPessoaMembro : Integer; SQLConn : TSQLConnection) : Boolean;
function inserirEndereco(logradouro_endereco, numero_endereco, bairro_endereco, cidade_endereco, uf_endereco, complemento, CEP : String; SQLConn : TSQLConnection) : Integer;
function alterarEndereco(tipo_endereco, logradouro_endereco, numero_endereco, bairro_endereco, cidade_endereco, uf_endereco, enderecocol : String; id_endereco : Integer; SqlConn : TSQLConnection) : Boolean;
function excluirEndereco(id_endereco : Integer; SqlConn : TSQLConnection) : Boolean;
function inserirProduto(descricao_produto, situacao : String;  estoque : Double;  id_categoria : Integer; SQLConn : TSQLConnection) : Integer;
function alterarProduto(descricao : String; id_produto : Integer; SQLConn : TSQLConnection) : Boolean;
function inativarProduto(id_produto : Integer; SqlConn : TSQLConnection) : Boolean;
function inserirmovimentacao(es_movimentacao : String; qtde_movimentacao : Double; id_tipo_movimentacao: Integer; SqlConn : TSQLConnection) : Boolean;

implementation


function inserirtelefone(numeroTel, OBS : String; SQLConn : TSQLConnection) : Integer;
var
  QInsere : TSQLQuery;
begin
  try
    try
      QInsere := TSQLQuery.Create(nil);
      QInsere.SQLConnection := SQLConn;

      with QInsere do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' insert into telefone (numero_telefone, obs_telefone) values (:numero_telefone, :obs_telefone) ');
        ParamByName('numero_telefone').AsString := numeroTel;
        ParamByName('obs_telefone').AsString := OBS;
        ExecSql;
      end;

      result := retornaId('telefone', 'id_telefone', SQLConn);

    Except
      ShowMessage('Erro ao inserir telefone.');
      result := 0;
    end;
  finally
    QInsere.Free;
  end;

  end;

function alterartelefone(numeroTel, OBS : String; id_telefone : Integer; SQLConn : TSQLConnection) : Boolean;
var
  QAltera : TSQLQuery;
begin
  try
    try
      QAltera := TSQLQuery.Create(nil);
      QAltera.SQLConnection := SQLConn;

      with QAltera do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' update telefone set numero_telefone = :numero_telefone, obs_telefone = :obs_telefone ');
        Sql.Add(' where id_telefone = :id_telefone ');
        ParamByName('numero_telefone').AsString := numeroTel;
        ParamByName('obs_telefone').AsString := OBS;
        ParamByName('id_telefone').AsInteger := id_telefone;
        ExecSql;
      end;
      result := True;

    except
      ShowMessage('Erro ao atualizar telefone.');
      result := False;
    end;
  finally
    QAltera.Free;
  end;
end;

function excluirtelefone(id_telefone : Integer; SqlConn : TSQLConnection) : Boolean;
var
  QDeleta : TSQLQuery;
begin
  try
    try
      QDeleta := TSQLQuery.Create(nil);
      QDeleta.SQLConnection := SQLConn;

      with QDeleta do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' delete from telefone where id_telefone = :id_telefone ');
        ParamByName('id_telefone').AsInteger := id_telefone;
        ExecSql;
      end;
      result := True;
    except
      ShowMessage('Erro ao excluir telefone.');
      result := False;
    end;
  finally
    QDeleta.Free;
  end;

end;

function retornaId(tabela, nomeId : String; SqlConn : TSQLConnection) : Integer;
var
  QBusca : TsqlQuery;
begin
  try
    try
      QBusca := TSQLQuery.Create(nil);
      QBusca.SQLConnection := SQLConn;

      with QBusca do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' select max(' + nomeId + ') as codigo from ' + tabela);
        Open;

        if not IsEmpty then
        begin
          result := FieldByName('codigo').AsInteger;
        end
        else
        begin
          result := 0;
        end;
      end;
    except
      ShowMessage('Erro ao consultar código.');
    end;
  finally
    QBusca.Free;
  end;
end;

function inserirfamilia(descricao, situacao : String; SqlConn : TSQLConnection) : Integer;
var
  QInsere : TSQLQuery;
begin
  try
    try

      result := 0;

      QInsere := TSQLQuery.Create(nil);
      QInsere.SQLConnection := SqlConn;

      with QInsere do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' insert into familia (descricao_familia, situacao) values (:descricao_familia, :situacao) ');
        ParamByName('descricao_familia').AsString := descricao;
        ParamByName('situacao').AsString := situacao;
        ExecSql;
      end;

      result := retornaId('familia', 'id_familia', SqlConn);

    Except
      ShowMessage('Falha ao inserir família.');
    end;
  finally
    QInsere.Free;
  end;
end;

function alterarfamilia(descricao : String; id_familia : Integer; SqlConn : TSQLConnection) : Boolean;
var
 QAltera : TSQLQuery;
begin
  try
    try
      result := false;

      QAltera := TSQLQuery.Create(nil);
      QAltera.SQLConnection := SqlConn;

      With QAltera do
      begin
        close;
        Sql.Clear;
        Sql.Add(' update familia set descricao_familia = :descricao_familia ');
        Sql.Add(' where id_familia = :id_familia ');
        ParamByName('descricao_familia').AsString := descricao;
        ParamByName('id_familia').AsInteger := id_familia;
        ExecSql;
      end;

      result := True;

    except
      ShowMessage('Erro ao atualizar família.')
    end;
  finally
    QAltera.Free;
  end;

end;

function inativarfamilia(id_familia: Integer; SqlConn : TSQLConnection) : Boolean;
var
  QInativa : TSQLQuery;
begin
  try
    try

      result := False;

      QInativa := TSQLQuery.Create(nil);
      QInativa.SQLConnection := SqlConn;

      with QInativa do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' update familia set situacao = ''Inativo'' where id_familia = :id_familia ');
        ParamByName('id_familia').AsInteger := id_familia;
        ExecSql;
      end;

      result := True;

    Except
      ShowMessage('Erro ao inativar familia.');
    end;
  finally
    QInativa.Free;
  end;
end;

function inserirpessoa(cnpj_cpf, rg_ie, razao, fisica_juridica, obs, situacao : String; dataNascimento : TdateTime; idTelefone, idEndereco, fornecedor, voluntario,
funcionario, beneficiario, doador : Integer; SqlConn : TSQLConnection) : Integer;
var
  QInsere : TSQLQuery;
begin
  try
    try
      result := 0;

      QInsere := TSQLQuery.Create(nil);
      QInsere.SQLConnection := SqlConn;

      with QInsere do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' insert into pessoa (CPF_CNPJ, RG_IE, razao_pessoa, dta_nascimento, fisica_juridica, id_telefone_pessoa, id_endereco_pessoa, ');
        Sql.Add(' fornecedor, voluntario, funcionario, beneficiado, doador, observacao, situacao, dta_inclusao_pessoa) values ');
        Sql.Add('  (:CPF_CNPJ, :RG_IE, :razao_pessoa, :dta_nascimento_pessoa, :fisica_juridica, :id_telefone_pessoa, :id_endereco_pessoa, ');
        Sql.Add('  :fornecedor, :voluntario, :funcionario, :beneficiado, :doador, :observacao, :situacao, :dta_inclusao_pessoa) ');
        ParamByName('CPF_CNPJ').AsString := cnpj_cpf;
        if rg_ie = '' then
        begin
          ParamByName('RG_IE').DataType := ftString;
          ParamByName('RG_IE').Clear;
        end
        else
        begin
          ParamByName('RG_IE').AsString := rg_ie;
        end;
        ParamByName('razao_pessoa').AsString := razao;
        if dataNascimento = Now() then
        begin
          ParamByName('dta_nascimento_pessoa').DataType := ftDate;
          ParamByName('dta_nascimento_pessoa').Clear;
        end
        else
        begin
          ParamByName('dta_nascimento_pessoa').AsDate := dataNascimento;
        end;
        ParamByName('fisica_juridica').AsString := fisica_juridica;
        if idTelefone <> 0 then
        begin
          ParamByName('id_telefone_pessoa').AsInteger := idTelefone;
        end
        else
        begin
          ParamByName('id_telefone_pessoa').DataType := ftInteger;
          ParamByName('id_telefone_pessoa').Clear;
        end;
        if idEndereco <> 0 then
        begin
          ParamByName('id_endereco_pessoa').AsInteger := idEndereco;
        end
        else
        begin
          ParamByName('id_endereco_pessoa').DataType := ftInteger;
          ParamByName('id_endereco_pessoa').Clear;
        end;

        ParamByName('fornecedor').AsInteger := fornecedor;
        ParamByName('voluntario').AsInteger := voluntario;
        ParamByName('funcionario').AsInteger := funcionario;
        ParamByName('beneficiado').AsInteger := beneficiario;
        ParamByName('doador').AsInteger := doador;
        ParamByName('observacao').AsString := obs;
        ParamByName('situacao').AsString := situacao;
        ParamByName('dta_inclusao_pessoa').AsDate := now();

        ExecSql;

      end;

      result := retornaId('pessoa', 'id_pessoa', SqlConn);

    except
      showMessage('Erro ao inserir pessoa.');
    end;
  finally
    QInsere.Free;
  end;
end;



function inativaativarpessoa(situacao : String; idPessoa : Integer; SqlConn : TSQLConnection) : Boolean;
var
  QAltera : TSQLQuery;
begin
  try
    try
      QAltera := TSQLQuery.Create(nil);
      QAltera.SQLConnection := SqlConn;

      with QAltera do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' update from pessoa set situacao = :situacao where id_pessoa = :id_pessoa ');
        ParamByName('situacao').AsString := situacao;
        ParamByname('id_pessoa').AsInteger := idPessoa;
        ExecSql;
      end;
      result := True;
    except
      ShowMessage('Erro ao inativar/ativar pessoa.');
      result := False;
    end;
  finally
    QAltera.Free;
  end;

end;

function inserirtipomovimentacao(descricao : String; SqlConn : TSQLConnection) : Integer;
var
  QInsere : TSQLQuery;
begin
  try
    try

      result := 0;

      QInsere := TSQLQuery.Create(nil);
      QInsere.SqlConnection := SqlConn;

      with QInsere do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' insert into tipo_movimentacao (descricao) values (:descricao) ');
        ParamByName('descricao').AsString := descricao;
        ExecSql;
      end;

      result := retornaId('tipo_movimentacao', 'id_tipo_movimentacao', SqlConn);

    Except
      ShowMessage('Falha ao inserir tipo movimentação.');
    end;
  finally
    QInsere.Free;
  end;
end;

function alterartipomovimentacao(id_tipo_movimentacao : Integer; descricao : String; SqlConn : TSQLConnection) : Boolean;
var
 QAltera : TSQLQuery;
begin
  try
    try
      result := false;

      QAltera := TSQLQuery.Create(nil);
      QAltera.SqlConnection := SqlConn;

      With QAltera do
      begin
        close;
        Sql.Clear;
        Sql.Add(' update tipo_movimentacao set descricao = :descricao ');
        Sql.Add(' where id_tipo_movimentacao = :id_tipo_movimentacao ');
        ParamByName('descricao').AsString := descricao;
        ParamByName('id_tipo_movimentacao').AsInteger := id_tipo_movimentacao;
        ExecSql;
      end;

      result := True;

    except
      ShowMessage('Erro ao atualizar tipo de movimentação.');
    end;
  finally
    QAltera.Free;
  end;

end;

function criptoMD5(senha : String) : String;
var
  xMD5 : TIdHashMessageDigest5;
begin
  xMD5 := TIdHashMessageDigest5.Create;
  try
    Result := LowerCase(xMD5.HashStringAsHex(senha));
  finally
    xMD5.Free;
  end;

end;

function inserirCategoria(descricaoCategoria : String; SQLConn : TSQLConnection) : Integer;
var
  QInsere : TSQLQuery;
begin
  try
    try
      QInsere := TSQLQuery.Create(nil);
      QInsere.SQLConnection := SQLConn;

      with QInsere do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' insert into categoria (descricao_categoria) values (:descricao_categoria) ');
        ParamByName('descricao_categoria').AsString := descricaoCategoria;
        ExecSql;
      end;
       // retornaId(tabela, nomeId, SqlConn)
      result := retornaId('categoria','id_categoria', SQLConn);
      //usei a função retornaId pensando que quando juntarmos as funções ela vai estar lá
    Except
      ShowMessage('Erro ao inserir categoria.');
      result := 0;
    end;
  finally
    QInsere.Free;
  end;
end;

function alterarCategoria(descricaoCategoria : String; idCategoria: Integer; SQLConn : TSQLConnection) : Boolean;
var
  QAltera : TSQLQuery;
begin
  try
    try
      QAltera := TSQLQuery.Create(nil);
      QAltera.SQLConnection := SQLConn;

      with QAltera do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' update categoria set descricao_categoria = :descricao_categoria');
        Sql.Add(' where id_categoria = :id_categoria ');
        ParamByName('descricao_categoria').AsString := descricaoCategoria;
        ParamByName('id_categoria').AsInteger := idCategoria;
        ExecSql;
      end;
      result := True;

    except
      ShowMessage('Erro ao atualizar categoria.');
      result := False;
    end;
  finally
    QAltera.Free;
  end;
end;

function excluirCategoria(idCategoria : Integer; SqlConn : TSQLConnection) : Boolean;
var
  QDeleta : TSQLQuery;
begin
  try
    try
      QDeleta := TSQLQuery.Create(nil);
      QDeleta.SQLConnection := SQLConn;

      with QDeleta do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' delete from categoria where id_categoria = :id_categoria');
        ParamByName('id_categoria').AsInteger := idCategoria;
        ExecSql;
      end;
      result := True;
    except
      ShowMessage('Erro ao excluir categoria.');
      result := False;
    end;
  finally
    QDeleta.Free;
  end;
end;

//funcoes de membro_familia
function inserirMembroFamilia(chefeFamilia : String; idFamiliaMembro, idPessoaMembro : Integer; SQLConn : TSQLConnection) : Boolean;
var
  QInsere : TSQLQuery;
begin
  try
    try
      QInsere := TSQLQuery.Create(nil);
      QInsere.SQLConnection := SQLConn;

      with QInsere do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' insert into membro_familia (chefe_familia, id_familia_membro, id_pessoa_membro) values (:chefe_familia, :id_familia_membro, :id_pessoa_membro ) ');
        ParamByName('chefe_familia').AsString := chefeFamilia;
        ParamByName('id_familia_membro').AsInteger := idFamiliaMembro;
        ParamByName('id_pessoa_membro').AsInteger := idPessoaMembro;
        ExecSql;
      end;
      result := True;
    Except
      ShowMessage('Erro ao inserir membro da família.');
      result := False;
    end;
  finally
    QInsere.Free;
  end;
end;

function alterarMembroFamilia(chefeFamilia : String; idFamiliaMembro, idPessoaMembro : Integer; SQLConn : TSQLConnection) : Boolean;
var
  QAltera : TSQLQuery;
begin
  try
    try
      QAltera := TSQLQuery.Create(nil);
      QAltera.SQLConnection := SQLConn;

      with QAltera do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' update membro_familia set chefe_familia = :chefe_familia');
        Sql.Add(' where id_familia_membro = :id_familia_membro and id_pessoa_membro = :id_pessoa_membro ');
        ParamByName('chefe_familia').AsString := chefeFamilia;
        ParamByName('id_familia_membro').AsInteger := idFamiliaMembro;
        ParamByName('id_pessoa_membro').AsInteger := idPessoaMembro;
        ExecSql;
      end;
      result := True;

    except
      ShowMessage('Erro ao atualizar membro da família.');
      result := False;
    end;
  finally
    QAltera.Free;
  end;
end;


function excluirMembroFamilia(idFamiliaMembro, idPessoaMembro : Integer; SqlConn : TSQLConnection) : Boolean;
var
  QDeleta : TSQLQuery;
begin
  try
    try
      QDeleta := TSQLQuery.Create(nil);
      QDeleta.SQLConnection := SQLConn;

      with QDeleta do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' delete from membro_familia where id_familia_membro = :id_familia_membro and id_pessoa_membro = :id_pessoa_membro');
        ParamByName('id_familia_membro').AsInteger := idFamiliaMembro;
        ParamByName('id_pessoa_membro').AsInteger := idPessoaMembro;
        ExecSql;
      end;
      result := True;
    except
      ShowMessage('Erro ao excluir membro da família.');
      result := False;
    end;
  finally
    QDeleta.Free;
  end;
end;

function inserirEndereco(logradouro_endereco, numero_endereco, bairro_endereco, cidade_endereco, uf_endereco, complemento, CEP : String; SQLConn : TSQLConnection) : Integer;
var
  QInsere : TSQLQuery;
begin
  try
    try
      QInsere := TSQLQuery.Create(nil);
      QInsere.SQLConnection := SQLConn;

      with QInsere do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' insert into endereco(logradouro_endereco, numero_endereco, bairro_endereco, cidade_endereco, uf_endereco, COMPLEMENTO_ENDERECO, CEP_ENDERECO) values');
        Sql.Add(' (:logradouro_endereco, :numero_endereco, :bairro_endereco, :cidade_endereco, :uf_endereco, :COMPLEMENTO_ENDERECO, :CEP_ENDERECO) ');
        ParamByName('logradouro_endereco').AsString := logradouro_endereco;
        ParamByName('numero_endereco').AsString := numero_endereco;
        ParamByName('bairro_endereco').AsString := bairro_endereco;
        ParamByName('cidade_endereco').AsString := cidade_endereco;
        ParamByName('uf_endereco').AsString := uf_endereco;
        ParamByName('COMPLEMENTO_ENDERECO').AsString := complemento;
        ParamByName('CEP_ENDERECO').AsString := CEP;
        ExecSql;
      end;

      result := retornaId('endereco', 'id_endereco', SQLConn);

      Except
        ShowMessage('Erro ao inserir endereco.');
        result :=0;
      end;
    finally
      QInsere.Free;
  end;

end;

function alterarEndereco(tipo_endereco, logradouro_endereco, numero_endereco, bairro_endereco, cidade_endereco, uf_endereco, enderecocol : String; id_endereco : Integer; SqlConn : TSQLConnection) : Boolean;
var
 QAltera : TSQLQuery;
begin
  try
    try
      result := false;

      QAltera := TSQLQuery.Create(nil);
      QAltera.SQLConnection := SQLConn;

      with QAltera do
      begin
        Close;
        Sql.Clear;
        Sql.add(' update endereco set '+' tipo_endereco = :tipo_endereco, logradouro_endereco = :logradouro_endereco, numero_endereco = :numero_endereco, bairro_endereco = :bairro_endereco, cidade_endereco = :cidade_endereco, uf_endereco = :uf_endereco, enderecocol = :enderecocol');
        Sql.Add(' where id_endereco = :id_endereco ');
        ParamByName('tipo_endereco').AsString := tipo_endereco;
        ParamByName('logradouro_endereco').AsString := logradouro_endereco;
        ParamByName('numero_endereco').AsString := numero_endereco;
        ParamByName('bairro_endereco').AsString := bairro_endereco;
        ParamByName('cidade_endereco').AsString := cidade_endereco;
        ParamByName('uf_endereco').AsString := uf_endereco;
        ParamByName('enderecocol').AsString := enderecocol;
        ParamByName('id_endereco').AsInteger := id_endereco;
        ExecSql;
      end;

      result := True;

      except
        ShowMessage('Erro ao atualizar endereco.');
      end;
    finally
      QAltera.Free;
    end;
  end;

function excluirEndereco(id_endereco : Integer; SQLConn : TSQLConnection) : Boolean;
var
 QDeleta : TSQLQuery;
begin
  try
    try
      QDeleta := TSQLQuery.Create(nil);
      QDeleta.SQLConnection := SQLConn;

      with QDeleta do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' delete from endereco where id_endereco = :id_endereco ');
        ParamByName('id_endereco').AsInteger := id_endereco;
        ExecSql;
      end;
      result := True;

      except
        ShowMessage('Erro ao excluir endereco.');
        result := False;
      end;
    finally
      QDeleta.Free;
    end;
  end;

function inserirProduto(descricao_produto, situacao : String;  estoque : Double;  id_categoria : Integer; SQLConn : TSQLConnection) : Integer;
var
  QInsere : TSQLQuery;
begin
  try
    try
      QInsere := TSQLQuery.Create(nil);
      QInsere.SQLConnection := SQLConn;

      with QInsere do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' INSERT INTO produto (DESCRICAO_PRODUTO, ID_CATEGORIA_PRODUTO, ESTOQUE, SITUACAO) VALUES ');
        Sql.Add(' (:DESCRICAO_PRODUTO,:ID_CATEGORIA_PRODUTO,:ESTOQUE,:SITUACAO) ');
        ParamByName('descricao_produto').AsString := descricao_produto;
        ParamByName('ID_CATEGORIA_PRODUTO').AsInteger := id_categoria;
        ParamByName('estoque').AsFloat := estoque;
        ParamByName('situacao').AsString := situacao;
        ExecSql;
      end;

      result := retornaId('produto', 'id_produto', SQLConn);

      Except
        ShowMessage('Erro ao inserir produto.');
        result :=0;
      end;
    finally
      QInsere.Free;
  end;
end;


function alterarProduto(descricao : String; id_produto : Integer; SqlConn : TSQLConnection) : Boolean;
var
 QAltera : TSQLQuery;
begin
  try
    try
      result := false;

      QAltera := TSQLQuery.Create(nil);
      QAltera.SqlConnection := SqlConn;

      With QAltera do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' update produto set descricao_produto = :descricao_produto ');
        Sql.Add(' where id_produto = :id_produto ');
        ParamByName('descricao_produto').AsString := descricao;
        ParamByName('id_produto').AsInteger := id_produto;
        ExecSql;
      end;
      result := True;

    except
      ShowMessage('Erro ao atualizar produto.')
    end;
  finally
    QAltera.Free;
  end;
end;

function inativarProduto(id_produto: Integer; SqlConn : TSQLConnection) : Boolean;
var
  QInativa : TSQLQuery;
begin
  try
    try
      result := False;

      QInativa := TSQLQuery.Create(nil);
      QInativa.SqlConnection := SqlConn;

      with QInativa do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' update produto set situacao = ''Inativo'' where id_produto = :id_produto ');
        ParamByName('id_produto').AsInteger := id_produto;
        ExecSql;
      end;
      result := True;

    Except
      ShowMessage('Erro ao inativar produto.');
    end;
  finally
    QInativa.Free;
  end;
end;

function inserirmovimentacao(es_movimentacao : String; qtde_movimentacao : Double; id_tipo_movimentacao: Integer; SqlConn : TSQLConnection) : Boolean;
var
  QInsere : TSQLQuery;
begin
  try
    try
      QInsere := TSQLQuery.Create(nil);
      QInsere.SQLConnection := SQLConn;

      with QInsere do
      begin
        Close;
        Sql.Clear;
        Sql.Add(' insert into movimentacao (E/S, qtde_movimentacao, id_tipo_movimentacao) values (:ES, :qtde_movimentacao, :id_tipo_movimentacao) ');
        ParamByName('ES').AsString := es_movimentacao;
        ParamByName('qtde_movimentacao').AsFloat := qtde_movimentacao;
        ParamByName('id_tipo_movimentacao').AsInteger := id_tipo_movimentacao;
        ExecSql;
      end;

      result := true;

    Except
        ShowMessage('Erro ao fazer a movimentação.');
        result :=false;
    end;
  finally
    QInsere.Free;
  end;
end;


end.
