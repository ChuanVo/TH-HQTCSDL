using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DAO
{
    class BillDAO
    {
        private static BillDAO instance;
        private object Datatable;       

        public static BillDAO Instance
        {
            get { if (instance == null) instance = new BillDAO(); return BillDAO.instance; }
            private set { BillDAO.instance = value; }
        }

        private BillDAO() { }

        public DataTable GetBill(string agency)
        {
            string query = "EXEC PROC_PHANTOM_T1_TRUNGDUC @id_agency='" + agency + "'";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            return data;
        }

        public bool UpdateBillStatus(string id, string agency, string status)
        {
            string query = "EXEC PROC_LOSTUPDATE_T1_LAM @id_bill='" + id + "',@agency='" + agency + "',@status='" + status + "'";

            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }
    }
}
