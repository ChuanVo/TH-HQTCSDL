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

        public DataTable GetBill()
        {
            string query = "SELECT * FROM BILL WHERE isActive = '1'";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            return data;
        }
    }
}
