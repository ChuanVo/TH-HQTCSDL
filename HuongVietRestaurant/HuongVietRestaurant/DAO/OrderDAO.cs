using HuongVietRestaurant.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DAO
{
    public class OrderDAO
    {
        private static OrderDAO instance;

        public static OrderDAO Instance
        {
            get { if (instance == null) instance = new OrderDAO(); return OrderDAO.instance; }
            private set { OrderDAO.instance = value; }
        }

        private OrderDAO() { }

        public List<Order> GetOrder(string id)
        {
            List<Order> listOrder = new List<Order>();

            string query = "SELECT DISH.dish_name, BILL_DETAIL.unit, DISH.price, DISH.price * BILL_DETAIL.unit AS totalPrice FROM BILL_DETAIL, DISH WHERE BILL_DETAIL.dish = DISH.id_dish AND BILL_DETAIL.id_bill = '" + id +"' ";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                Order order = new Order(item);
                listOrder.Add(order);
            }

            return listOrder;
        }
    }
}
