from typing import Optional

from sqlalchemy.orm import Mapped, mapped_column, relationship
from .base import CreatedUpdatedAtMixin


class User(CreatedUpdatedAtMixin):
    __tablename__ = 'users'

    user_id: Mapped[int] = mapped_column(primary_key=True)
    password: Mapped[str]
    email: Mapped[Optional[str]]
    first_name: Mapped[Optional[str]]
    last_name: Mapped[Optional[str]]
    address1: Mapped[Optional[str]]
    address2: Mapped[Optional[str]]
    zipcode: Mapped[Optional[str]]
    city: Mapped[Optional[str]]
    state: Mapped[Optional[str]]
    country: Mapped[Optional[str]]
    phone: Mapped[Optional[str]]

    cart = relationship("Cart", back_populates="user")
    order = relationship("Order", back_populates="user")
