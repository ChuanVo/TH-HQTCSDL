using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DAO
{
    class PayDAO
    {
        private static PayDAO instance;
        private object Datatable;

        public static PayDAO Instance
        {
            get { if (instance == null) instance = new PayDAO(); return PayDAO.instance; }
            private set { PayDAO.instance = value; }
        }

        private PayDAO() { }

        public DataTable GetMenu(string user)
        {
            string query = "usp_GetMenu @user_name = '" + user + "'";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            return data;
        }

        public bool PayDish(string id, string agency, int unit)
        {
            string query = "EXEC PROC_LOSTUPDATE_T2_LANG @id_dish='" + id + "', @unit='" + unit + "', @id_agency='" + agency + "'";

            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }
    }
}
