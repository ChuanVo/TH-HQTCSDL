using HuongVietRestaurant.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DAO
{
    public class BillDetailDAO
    {
        private static BillDetailDAO instance;

        public static BillDetailDAO Instance
        {
            get { if (instance == null) instance = new BillDetailDAO(); return BillDetailDAO.instance; }
            private set { BillDetailDAO.instance = value; }
        }

        private BillDetailDAO() { }

        public List<BillDetail> GetBillDetail(string id)
        {
            List<BillDetail> dt = new List<BillDetail>();

            string query = "SELECT * FROM dbo.BILL_DETAIL WHERE id_bill = " + id;

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                BillDetail billDetail = new BillDetail(item);
                dt.Add(billDetail);
            }

            return dt;
        }

        public void InsertBillInfo(string idBill, string idFood, int unit)
        {
            DataProvider.Instance.ExecuteNonQuery("exec USP_Insert_Bill_Detail @id_bill , @id_food , @unit ", new object[] { idBill, idFood, unit });
        }

    }
}
