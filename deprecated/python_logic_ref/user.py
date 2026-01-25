from pydantic import BaseModel, EmailStr
from typing import Optional

class UserBase(BaseModel):
    username: str
    email: EmailStr
    height: Optional[float] = None
    weight: Optional[float] = None
    body_type: Optional[str] = None
    goal: Optional[str] = None

class UserCreate(UserBase):
    password: str

class UserUpdate(BaseModel):
    height: Optional[float] = None
    weight: Optional[float] = None
    body_type: Optional[str] = None
    goal: Optional[str] = None

class User(UserBase):
    id: int
    
    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    username: Optional[str] = None
