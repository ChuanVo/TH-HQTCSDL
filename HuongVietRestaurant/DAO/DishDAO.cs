using HuongVietRestaurant.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DAO
{
    public class DishDAO
    {
        private static DishDAO instance;
        private object Datatable;

        public static DishDAO Instance
        {
            get { if (instance == null) instance = new DishDAO();return DishDAO.instance; }
            private set { DishDAO.instance = value; }
        }

        private DishDAO() {}

        public DataTable GetListDish()
        {
            string query = "EXEC usp_GetLishDish";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            return data;
        }

        public bool AddDish(string id, string type_dish, string dish_name, int price, string image, int unit, string agency)
        {
            string query = "EXEC usp_AddDish @id_dish = '" + id + "', @type_dish_name = '" + type_dish + "', @dish_name = '" + dish_name + "', @price = '" + price + "', @image = '" + image + "', @unit = '" + unit + "' , @agency = '" + agency + "' ";

            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 1;
        }

        public bool UpdateDish(string id, string type_dish, string dish_name, int price, string image, int unit)
        {
            string query = "EXEC usp_UpdateDish @id_dish = '" + id + "', @type_dish_name = '" + type_dish + "', @dish_name = '" + dish_name + "', @price = '" + price + "', @image = '" + image + "', @unit = '" + unit + "' ";

            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 1;
        }

        public bool DeleteDish(string id_dish)
        {
            string query = "EXEC usp_DeleteDish @id_dish = '" + id_dish + "' ";

            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 1;
        }
    }
}
