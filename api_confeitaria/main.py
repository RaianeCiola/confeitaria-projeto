from __future__ import annotations
# from urllib import request
from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.orm import Session
from models.models import Cliente, ClienteBase 
from data.config import SessionLocal, engine, Base

from models.models import Cliente, ClienteResponse, ClienteRequest
from data.config import engine, Base, get_db
from repository.confeitaria_repository import ClienteRepository

from models.models import Produto, ProdutoRequest, ProdutoResponse
from repository.confeitaria_repository import ProdutoRepository

from models.models import Pedido, PedidoRequest, PedidoResponse
from repository.confeitaria_repository import PedidoRepository
from fastapi.middleware.cors import CORSMiddleware
#
# INICIALIZAÇÃO
#
Base.metadata.create_all(bind=engine)
app = FastAPI(
    title="API CONFEITARIA",
    description="Esta API fornece operações de gerenciamento de uma CONFEITARIA.",
    version="1.0.0"
)


origins = ['*']
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Função para obter a sessão do banco
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()



#  criar um novo cliente POST
@app.post("/api/cliente1/post", tags=["Clientes"])
def criar_cliente(request: ClienteBase, db: Session = Depends(get_db)):
    novo_cliente = Cliente(nome=request.nome, telefone=request.telefone, email=request.email)
    db.add(novo_cliente)
    db.commit()
    db.refresh(novo_cliente)
    return novo_cliente


#Retorna cliente por id GET_BY_ID
@app.get("/api/cliente1/get_by_id{id}", response_model=ClienteResponse, tags=["Clientes"])
def obter_cliente(id: int, db:Session = Depends(get_db)):
    cliente = ClienteRepository.get_by_id(db,id)
    if (not cliente):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,detail='Cliente não encontrado.')
    return cliente

#Retorna lista cliente GET_ALL
@app.get("/api/clientes2_get/", response_model=list[ClienteResponse], tags=["Clientes"])
def listar_clientes(db: Session = Depends(get_db)):
    try:
        clientes = db.query(Cliente).all()
        return clientes
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )
    
 #Atulaiza cliente PUT   
@app.put("/api/cliente3/Put/{id}", response_model=ClienteResponse, tags=["Clientes"])
def atualizar_cliente(id: int, request: ClienteRequest, db: Session = Depends(get_db)):
    cliente = db.query(Cliente).filter(Cliente.id == id).first()
    if not cliente:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cliente não encontrado.")
    cliente.nome = request.nome
    cliente.telefone = request.telefone
    cliente.email = request.email
    db.commit()
    db.refresh(cliente)
    return cliente


#Deleta cliente DELETE
@app.delete("/api/cliente3/Delete/{id}", status_code=status.HTTP_204_NO_CONTENT, tags=["Clientes"])
def deletar_cliente(id: int, db: Session = Depends(get_db)):
    cliente = db.query(Cliente).filter(Cliente.id == id).first()
    if not cliente:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cliente não encontrado.")
    db.delete(cliente)
    db.commit()
    return {"message": "Cliente deletado com sucesso"}



#----------------------- PRODUTO -------------------------------------------------------#


# listar todos os produtos  GET
@app.get("/api/produtos/get_all", response_model=list[ProdutoResponse], tags=["Produtos"])
def listar_produtos(db: Session = Depends(get_db)):
    return ProdutoRepository.get_all(db)


# criar um novo produto POST
@app.post("/api/produtos/post", response_model=ProdutoResponse, status_code=status.HTTP_201_CREATED, tags=["Produtos"])
def criar_produtp(request: ProdutoRequest, db:Session = Depends(get_db)):
    return ProdutoRepository.salvar(db,Produto(**request.model_dump()))


#  deletar um produto por ID DELETE
@app.delete("/api/produtos/delete/{id}", status_code=status.HTTP_204_NO_CONTENT, tags=["Produtos"])
def deletar_produto(id: int, db: Session = Depends(get_db)):
    if not ProdutoRepository.deletar(db, id):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Produto não encontrado.")
    return {"message": "Produto deletado com sucesso"}

#ATUALIZAR UM PRODUTO PUT
@app.put("/api/produtos/put/{id}", response_model=ProdutoResponse, tags=["Produtos"])
def atualizar_produtos(id: int, request: ProdutoRequest, db: Session = Depends(get_db)):
    produto = db.query(Produto).filter(Produto.id == id).first()
    if not produto:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Produto não encontrado.")
    produto.nome = request.nome
    produto.descricao = request.descricao
    produto.preco = request.preco
    produto.categoria = request.categoria
    produto.disponibilidade = request.disponibilidade
    db.commit()
    db.refresh(produto)
    return produto

#  LISTA um produto por ID GET_by_id
@app.get("/api/produtos/get_by_id{id}", response_model=ProdutoResponse, tags=["Produtos"])
def get_by_id(id: int, db: Session = Depends(get_db)):
    produto = ProdutoRepository.get_by_id(db, id)
    if not produto:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Pedidi não encontrado.")
    return produto


#--------------------------------------- PEDIDO ------------------------------------#

# listar todos os pedidos GET
@app.get("/api/pedidos/", response_model=list[PedidoResponse], tags=["Pedidos"])
def listar_pedidos(db: Session = Depends(get_db)):
    return PedidoRepository.get_all(db)


# criar um novo pedido POST
@app.post("/api/pedido/", response_model=PedidoResponse, status_code=status.HTTP_201_CREATED, tags=["Pedidos"])
def criar_pedido(request: PedidoRequest, db: Session = Depends(get_db)):
    # Verificar se o cliente existe
    cliente = ClienteRepository.get_by_id(db, request.id_cliente)
    if not cliente:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Cliente com ID {request.id_cliente} não encontrado."
        )

    # Verificar se o produto existe
    produto = ProdutoRepository.get_by_id(db, request.id_produto)
    if not produto:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Produto com ID {request.id_produto} não encontrado."
        )

    #Quando for inserir novo pedido resgatar o preço do produto e colocar no tottal
    total = produto.preco

    # Criar o novo pedido
    novo_pedido = Pedido(
        id_cliente=request.id_cliente,
        id_produto=request.id_produto,
        data_pedido=request.data_pedido,
        status=request.status,
        total=total
    )
    db.add(novo_pedido)
    db.commit()
    db.refresh(novo_pedido)
    return novo_pedido

#  LISTA um pedido por ID GET_by_id
@app.get("/api/pedidos/{id}", response_model=PedidoResponse, tags=["Pedidos"])
def obter_pedido(id: int, db: Session = Depends(get_db)):
    pedido = PedidoRepository.get_by_id(db, id)
    if not pedido:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Pedido não encontrado.")
    return pedido

#  deletar um produto DELETE
@app.delete("/api/pedidos/{id}", status_code=status.HTTP_204_NO_CONTENT, tags=["Pedidos"])
def deletar_pedido(id: int, db: Session = Depends(get_db)):
    deletado = PedidoRepository.deletar(db, id)
    if not deletado:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Pedido não encontrado.")
    return {"message": "ProduPedidoo deletado com sucesso"}

#atualizar pedido PUT 
@app.put("/api/pedidos/{id}", response_model=PedidoResponse, tags=["Pedidos"])
def atualizar_pedido(id: int, request: PedidoRequest, db: Session = Depends(get_db)):
    pedido = db.query(Pedido).filter(Pedido.id == id).first()
    if not pedido:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Pedido não encontrado.")
    pedido.id_cliente = request.id_cliente
    pedido.id_produto = request.id_produto
    pedido.data_pedido = request.data_pedido
    pedido.status = request.status
    pedido.total = request.total
    db.commit()
    db.refresh(pedido)
    return pedido
