pragma solidity 0.5.1;
import "./Course.sol";

contract Manager {
    //Address of the school administrator
    address admin;
    
    mapping (address => int) student;
    mapping (address => bool) isStudent;
    mapping (int => bool) isCourse;
    mapping (int => Course) course;
    
    int rollCount = 19111000;
    
    //Constructor
    constructor() public
    {
        admin = msg.sender;   
    }
    
    modifier onlyAdmin
    {
        require(
            msg.sender == admin,
            "Only admin can call this function."
        );
        _;
    }
    
    
    function kill() public onlyAdmin
    {
        selfdestruct((address)((uint160)(admin)));
        //The admin has the right to kill the contract at any time.
        //Take care that no one else is able to kill the contract

    }
    
    function addStudent() public
    {
        address newstud;
        newstud = msg.sender;
        
        require(
            !isStudent[newstud],
            "newstud is not unique"
        );
        require(
            student[newstud] == 0,
            "rollNo is already a student"
        );
        
        student[newstud] = rollCount;
        rollCount = rollCount + 1;
        //update the mapping
        isStudent[newstud] = true;
        //Anyone on the network can become a student if not one already
        //Remember to assign the new student a unique roll number

    }
    
    function addCourse(int courseNo, address instructor) public onlyAdmin
    {
        require(
            !isCourse[courseNo],
            "course already exists"
        );
        
         Course newC = new Course(courseNo, instructor, admin);
         course[courseNo] = newC;
         
         //update mapping
         isCourse[courseNo] = true;
	    //Add a new course with cou/rse number as courseNo, and instructor at address instructor
        //Note that only the admin can add a new course. Also, don't create a new course if course already exists

    }
    
    function regCourse(int courseNo) public 
    {
        require(
            isCourse[courseNo],
            "course does not exists, invalid courseNo"
        );
        
        
        address studaddr = msg.sender;

        require(
            isStudent[studaddr],
            "Only RegStudent or invalid rollNo"
        );
        
        Course C = course[courseNo];
        int rollNo = student[studaddr];
        C.enroll(rollNo);
        //Register the student in the course if he is a student on roll and the courseNo is valid

    }
    
    function getMyMarks(int courseNo) public view returns(int, int, int)
    {
        require(
            isCourse[courseNo],
            "invalid courseNo"
        );
        
        address studaddr = msg.sender;

        require(
            isStudent[studaddr],
            "Only Student or invalid rollNo"
        );
        
        Course C = course[courseNo];
        int rollNo = student[studaddr];
        return (C.getMidsemMarks(rollNo), C.getEndsemMarks(rollNo), C.getAttendance(rollNo));
        //Check the courseNo for validity
        //Should only work for valid students of that course
	    //Returns a tuple (midsem, endsem, attendance)

    }
    
    function getMyRollNo() public view returns(int)
    {
        address studaddr = msg.sender;
        
        require(
            isStudent[studaddr],
            "student addr does not exists, invalid student"
        );
        
        require(
            student[studaddr]!=0,
            "rollNo is invalid, invalid student"
        );

        return student[studaddr];
        
        //Utility function to help a student if he/she forgets the roll number
        //Should only work for valid students
	    //Returns roll number as int
    }
    
}
