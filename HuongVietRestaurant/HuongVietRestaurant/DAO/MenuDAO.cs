using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HuongVietRestaurant.DTO;


namespace HuongVietRestaurant.DAO
{
    public class MenuDAO
    {
        public static int btnWidth = 95;
        public static int btnHeight = 95;

        private static MenuDAO instance;

        public static MenuDAO Instance
        {
            get { if (instance == null) instance = new MenuDAO(); return MenuDAO.instance; }
            private set { MenuDAO.instance = value; }
        }

        private MenuDAO() { }

        public List<Menu> GetMenu(string agencyID, string categoryID)
        {
            List<Menu> list = new List<Menu>();
            string query;
            if (categoryID == null)
            {
                query = "PROC_UNREPEATABLEREAD_T1_CHUAN @id_agency = '" + agencyID + "'";
            }
            else
            {
                query = "PROC_PHANTOM_T1_ANHOA @id_agency = '" + agencyID + "', @type_dish = N'" + categoryID + "'";
            }

            //string query = "PROC_PHANTOM_T1_CHUANVO @id_agency ";
            DataTable data = DataProvider.Instance.ExecuteQuery_TwoTable(query);

            foreach (DataRow item in data.Rows)
            {
                Menu menu = new Menu(item);
                list.Add(menu);
            }

            return list;
        }

        public void UpdateMenu(string agencyID, string foodID, int unit)
        {
            DataProvider.Instance.ExecuteNonQuery("PROC_LOSTUPDATE_T1_ANHOA @id_agency , @id_dish , @unit ", new object[] { agencyID, foodID, unit });
        }
    }
}
