using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DAO
{
    class PositionDAO
    {
        private static PositionDAO instance;
        private object Datatable;

        public static PositionDAO Instance
        {
            get { if (instance == null) instance = new PositionDAO(); return PositionDAO.instance; }
            private set { PositionDAO.instance = value; }
        }

        private PositionDAO() { }

        public DataTable GetPosition()
        {
            string query = "SELECT * FROM POSITION WHERE isActive = '1'";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            return data;
        }
    }
}
