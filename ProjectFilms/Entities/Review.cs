using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProjectFilms.Entities
{
	public class Review
	{
		public int Id { get; set; }
		public Film Film { get; set; }
		public User User { get; set; }
		public string ReviewComment { get; set; }
		public int Rating { get; set; }
		public DateTime TimeStamp { get; set; }
		public string TimeStampString { get; set; }
	}
}