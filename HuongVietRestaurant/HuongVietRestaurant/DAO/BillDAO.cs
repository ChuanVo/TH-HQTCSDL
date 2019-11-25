using HuongVietRestaurant.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DAO
{
    public class BillDAO
    {
        private static BillDAO instance;

        public static BillDAO Instance
        {
            get { if (instance == null) instance = new BillDAO(); return BillDAO.instance; }
            private set { BillDAO.instance = value; }
        }

        private BillDAO() { }

        public List<Bill> GetListBill()
        {
            List<Bill> list = new List<Bill>();

            string query = "SELECT * FROM dbo.BILL";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                Bill bill = new Bill(item);
                list.Add(bill);
            }

            return list;
        }



        public void InsertBill(string id_bill, string id_agency)
        {
            DataProvider.Instance.ExecuteNonQuery("exec USP_Insert_Bill @id_bill , @id_agency ", new object[] { id_bill, id_agency });
        }

        public string GetMaxIDBill()
        {
            
            return DataProvider.Instance.ExecuteScalar("SELECT MAX(CAST(STUFF(id_bill, 1, 5, '') AS INT)) + 1 FROM BILL").ToString();
        }


    }
}
