using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DAO
{
    class MenuDAO
    {
        private static MenuDAO instance;
        private object Datatable;

        public static MenuDAO Instance
        {
            get { if (instance == null) instance = new MenuDAO(); return MenuDAO.instance; }
            private set { MenuDAO.instance = value; }
        }

        private MenuDAO() { }

        public DataTable GetDish()
        {
            string query = "SELECT * FROM DISH WHERE isActive = '1'";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            return data;
        }

        public DataTable GetMenu(string user)
        {
            string query = "usp_GetMenu @user_name = '" + user + "'";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            return data;
        }

        public bool UpdateUnitDish(string id, string id_agency, int unit)
        {
            string query = "EXEC PROC_DIRTYREAD_T1_ANHOA @id_agency ='" + id_agency + "', @id_dish='" + id + "', @unit='" + unit + "'";

            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }

        public bool AddDishForMenu(string id, string id_agency, int unit)
        {
            string query = "EXEC PROC_PHANTOM_T2_CHUANVO @id_agency = '" + id_agency + "', @id_dish='" + id + "', @unit='" + unit + "'";

            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }
    }
}
