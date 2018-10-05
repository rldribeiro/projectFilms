using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProjectFilms.Entities
{
	public class Film
	{
		public List<Crew> Crew { get; set; }
		public List<Review> Reviews { get; set; }
		public List<Country> Countries { get; set; }
		public List<Language> Languages { get; set; }
		public List<Studio> Studios { get; set; }
		public List<Genre> Genres { get; set; }

		public int Id { get; set; }
		public string Title { get; set; }
		public DateTime ReleaseDate { get; set; }
		public string ReleaseDateString { get; set; }
		public int RunTime { get; set; }
		public string ImgPoster { get; set; }		
		public string TagLine { get; set; }
		public string Synopsis { get; set; }
		public string ImdbCode { get; set; }
	}
}