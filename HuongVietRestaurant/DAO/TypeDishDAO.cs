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

        public DataTable GetListTypeDish()
        {
            string query = "EXEC usp_GetLishTypeDish";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            return data;
        }
    }
}
