using HuongVietRestaurant.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DAO
{
    public class AgencyDAO
    {
        private static AgencyDAO instance;

        public static AgencyDAO Instance
        {
            get { if (instance == null) instance = new AgencyDAO(); return AgencyDAO.instance; }
            private set { AgencyDAO.instance = value; }
        }

        private AgencyDAO() { }

        public List<Agency> GetListAgency()
        {
            List<Agency> list = new List<Agency>();

            string query = "select * from dbo.AGENCY ";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                Agency agency = new Agency(item);
                list.Add(agency);
            }

            return list;
        }

        
    }

}
