using HuongVietRestaurant.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DAO
{
    class TypeDishDAO
    {
        private static TypeDishDAO instance;
        private object Datatable;

        public static TypeDishDAO Instance
        {
            get { if (instance == null) instance = new TypeDishDAO(); return TypeDishDAO.instance; }
            private set { TypeDishDAO.instance = value; }
        }

        private TypeDishDAO() { }

        public DataTable GetTypeDish()
        {
            string query = "SELECT * FROM TYPE_DISH WHERE isActive = '1'";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            return data;
        }

        public List<TypeDish> GetListTypeDish()
        {
            List<TypeDish> list = new List<TypeDish>();

            string query = "EXEC usp_GetLishTypeDish";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach(DataRow item in data.Rows)
            {
                TypeDish typedish = new TypeDish(item);

                list.Add(typedish);
            }

            return list;
        }

        public TypeDish GetTypeDishByID(string id)
        {
            TypeDish list = null;

            string query = "EXEC usp_GetTypeDishtoCCB @id = '" + id + "'";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                list = new TypeDish(item);

                return list;
            }

            return list;
        }

        public bool DelTypeDish(string id_type_dish)
        {
            string query = "EXEC PROC_UNREPEATABLEREAD_T2_LANG @id_type_dish = '" + id_type_dish + "' ";

            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }
    }
}
