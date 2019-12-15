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

        public List<Menu> GetMenu(string agencyID)
        {
            List<Menu> list = new List<Menu>();

            string query = "PROC_UNREPEATABLEREAD_T1_CHUAN @id_agency ";
            DataTable data = DataProvider.Instance.ExecuteQuery(query, new object[]{ agencyID });

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
