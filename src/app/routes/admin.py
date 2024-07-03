from __future__ import annotations


from flask import Blueprint, session, redirect, url_for, render_template, flash, g

from src.app.controllers import OrderController
from src.app.routes.user import login_required

admin_area_blueprint = Blueprint("admin_area", __name__, url_prefix="/admin")
admin_product_info_blueprint = Blueprint("admin_product_info", __name__, url_prefix="/admin/products")
admin_orders_info_blueprint = Blueprint("admin_orders_info", __name__, url_prefix="/admin/orders")


@admin_area_blueprint.route("/")
@login_required
def admin_area():
    first_name = session["first_name"]
    if "admin" not in first_name:
        flash("You are not an admin", "warning")
        return redirect(url_for('root.root'))
    return render_template('adminArea.html', firstName=first_name, noOfItems=session["no_of_items"],
                           loggedIn=session["logged_in"])


@admin_product_info_blueprint.route("/")
@login_required
def admin_available_products_statistics():
    return redirect(url_for('root.root'))


@admin_orders_info_blueprint.route("/")
def admin_orders_statistics():
    ses = g.session
    orders = OrderController(ses).get_orders_with_product_info()

    dynamic_data_table = get_dynamic_table(orders)

    return render_template("adminOrderStats.html", cloumnHeaders=dynamic_data_table[0],
                           tableValues=dynamic_data_table[1:],
                           firstName=session["first_name"], noOfItems=session["no_of_items"],
                           loggedIn=session["logged_in"])


def get_dynamic_table(orders: list[list[str | int]]) -> list[list[str | int]]:
    """
    orders besteht aus einer Liste aus Listen. Eine Liste besteht jeweils aus einer order_item_id (int), einer order_id (int) und
    dem product_name (str).

    :param orders: list[list[str | int]] Rohe Daten, aus welchen eine Statistik erstellt wird
    :return: das 2d Array mit der Statistik mit den product_name als Spaltennamen und der order_id als Reihennamen
    """

    # TODO: Code zum fixen des Tests verstehen und Codequalität verbessern
    if not orders:
        return orders

    dry_run: bool = False
    if dry_run:
        pass

    allProductNames: list[str] = []
    all_orders: dict[int, dict[str, int]] = {}
    any: str = ""

    for order_item_id, order_id, product_name in orders:
        # Collect unique product names for column headers
        if product_name not in allProductNames:
            allProductNames.append(product_name)

        # Counts the number of each product_name in the order per order_id
        if order_id in all_orders:
            if product_name in all_orders[order_id]:
                all_orders[order_id][product_name] = all_orders[order_id][product_name] + 1
            elif product_name not in all_orders[order_id]:
                all_orders[order_id][product_name] = 1
        else:
            all_orders[order_id] = {product_name: 1}
    print(all_orders)

    # Sort column headers in lexicographical order (by chars in unicode value range) ascending from low to high
    allProductNames = sorted(allProductNames)
    all_column_headers: list[str | int] = ["Order ID"] + [d for d in allProductNames]

    dynamic_table: list[list[str | int]] = [all_column_headers]
    test: int = 0

    # Fill 2d array with values, where column headers are product name and row headers are order id
    for row_order_id in sorted(all_orders, key=int):  # Sorts tables ascending by order_id from low int to high int
        rows: list[str | int] = [row_order_id]
        for i in range(1, len(all_column_headers)):
            current_product: str = all_column_headers[i]
            if current_product in all_orders[row_order_id]:
                rows.append(all_orders[row_order_id][current_product])
            else:
                rows.append(0)
        dynamic_table.append(rows)

    # Creates total row containing the total for each column
    total_row: list[str | int] = ["Total"]
    for column in list(zip(*dynamic_table[1:]))[1:]:
        total_row.append(sum(column))

    dynamic_table.append(total_row)



    total_Column: list[str | int] = ["Total"]
    for rows in list(zip(*dynamic_table[1:]))[1:]:
        total_Column.append(sum(rows))

    dynamic_table.append(total_Column)

    dynamic_table = calculate_row_totals(dynamic_table)

    # for row in dynamic_table:
    #     print(row)

    return dynamic_table if (not (((len(dynamic_table))) <= 1)) else []


def calculate_row_totals(dynamic_table: list[list[str | int]]) -> list[list[str | int]]:
    return dynamic_table


def calculate_column_totals(dynamic_table: list[list[str | int]]) -> list[list[str | int]]:
    pass
