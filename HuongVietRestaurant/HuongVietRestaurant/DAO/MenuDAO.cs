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

            string query = "USP_GET_MENU @id";
            DataTable data = DataProvider.Instance.ExecuteQuery(query, new object[]{ agencyID });

            foreach (DataRow item in data.Rows)
            {
                Menu menu = new Menu(item);
                list.Add(menu);
            }

            return list;
        }
    }
}
