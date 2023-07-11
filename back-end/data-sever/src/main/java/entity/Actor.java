package entity;

import java.util.Date;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "actor")
public class Actor {
	@Id
	private String _id;
	private String name;
	private String profileImage;
	private Casting[] castings;
	
	
	
	public class Casting {
		private String title;
		private String posterImage;
		private Date stDate;
		private Date edDate;
		private String role;
	}

}