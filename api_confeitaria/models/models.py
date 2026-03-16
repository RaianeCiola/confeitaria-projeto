from sqlalchemy import Column, Integer, String, Numeric, ForeignKey
from data.config import Base
from pydantic import BaseModel

class Cliente(Base):
    __tablename__ = "tb_cliente"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String(80), nullable=False)
    email = Column(String(80), nullable=False)
    telefone = Column(String(20), nullable=False)

class ClienteBase(BaseModel):
    nome: str
    email: str
    telefone: str

class ClienteRequest(ClienteBase):
    ...

class ClienteResponse(ClienteBase):
    id: int

    class Config:
        from_attributes = True
        populate_by_name = True

########################################



class Produto(Base):
    __tablename__ = "tb_produto"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String(80), nullable=False)
    descricao = Column(String(80))
    preco = Column(Numeric(10, 2), nullable=False)
    categoria = Column(String(50))
    disponibilidade = Column(String(12))

class ProdutoBase(BaseModel):
    nome: str
    descricao: str
    preco: float
    categoria: str
    disponibilidade: str

class ProdutoRequest(ProdutoBase):
    ...

class ProdutoResponse(ProdutoBase):
    id: int

    class Config:
        orm_mode = True
        populate_by_name = True

######################################
class Pedido(Base):
    __tablename__ = "tb_pedido"

    id = Column(Integer, primary_key=True, index=True)
    id_cliente = Column(Integer, ForeignKey("tb_cliente.id"), nullable=False)
    id_produto = Column(Integer, ForeignKey("tb_cliente.id"), nullable=False)
    data_pedido = Column(String(12))
    status = Column(String(20))
    total = Column(Numeric(10, 2))


class PedidoBase(BaseModel):
    id_cliente: int
    id_produto: int
    data_pedido: str
    status: str
    total: float

class PedidoRequest(PedidoBase):
    ...

class PedidoResponse(PedidoBase):
    id: int

    class Config:
        orm_mode = True
        populate_by_name = True
