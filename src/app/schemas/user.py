from typing import Optional

from pydantic import BaseModel, ConfigDict


class UserCreate(BaseModel):
    password: str
    email: Optional[str]
    first_name: Optional[str]
    last_name: Optional[str]
    address1: Optional[str]
    address2: Optional[str]
    zipcode: Optional[str]
    city: Optional[str]
    state: Optional[str]
    country: Optional[str]
    phone: Optional[str]


class User(UserCreate):
    user_id: int

    model_config = ConfigDict(from_attributes=True, extra="ignore")


class UserUpdate(UserCreate):
    pass
