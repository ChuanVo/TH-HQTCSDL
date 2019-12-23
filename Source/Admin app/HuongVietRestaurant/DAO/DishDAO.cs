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

        public DataTable GetListDish(string id_dish, string user)
        {
            string query;

            if (id_dish == null)
            {
                query = "EXEC usp_GetLishDish @user_name = N'" + user + "' ";
            }
            else
            {
                query = "EXEC PROC_PHANTOM_T1_LANG @id_type = '" + id_dish + "', @user_name = N'" + user + "'";
            }
            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            return data;
        }

        public DataTable GetListDishByIDType(string user, string id_type_dish)
        {
            string query = "EXEC PROC_PHANTOM_T1_LANG @id_type='" + id_type_dish + "',@user_name='" + user + "'";           

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            return data;
        }

        public bool AddDish(string id, string type_dish, string dish_name, int price, string image)
        {
            string query = "EXEC PROC_PHANTOM_T2_LANG @id_dish = '" + id + "', @id_type = '" + type_dish + "', @dish_name = N'" + dish_name + "', @price = '" + price + "', @image = '" + image + "', @isActive = '1'";

            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }

        public bool DeleteDish(string id_dish)
        {
            string query = "EXEC PROC_DelDish @id_dish = '" + id_dish + "' ";

            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }

        public bool UpdatePriceDish(string id, int price)
        {
            string query = "EXEC PROC_UNREPEATABLEREAD_T2_CHUAN @id_dish = '" + id + "', @price = '" + price + "'";

            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }

        public bool UpdateImageDish(string id, string Image)
        {
            string query = "EXEC PROC_DIRTYREAD_T1_LANG @id_dish = '" + id + "', @image = '" + Image + "'";

            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }

        public bool UpdateNameDish(string id, string name)
        {
            string query = "EXEC PROC_LOSTUPDATE_T1_TRUNGDUC @id_dish='" + id + "',@name=N'" + name + "'";

            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }

        public bool UpdateTypeDish(string id, string id_type_dish)
        {
            string query = "EXEC PROC_LOSTUPDATE_T1_TRUNGDUC @id_dish='" + id + "',@name=N'" + id_type_dish + "'";

            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }
    }
}
