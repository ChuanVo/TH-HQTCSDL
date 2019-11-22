using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DAO
{
    class AgencyDAO
    {
        private static AgencyDAO instance;
        private object Datatable;

        public static AgencyDAO Instance
        {
            get { if (instance == null) instance = new AgencyDAO(); return AgencyDAO.instance; }
            private set { AgencyDAO.instance = value; }
        }

        private AgencyDAO() { }

        public DataTable GetListAgency()
        {
            string query = "EXEC usp_GetLishAgency";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            return data;
        }
    }
}
