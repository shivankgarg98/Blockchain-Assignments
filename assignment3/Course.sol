pragma solidity 0.5.1;

contract Course
{
    
    address admin;
    address ManagerContract;
    address instructor;
    int courseNo;
    
    struct Marks
    {
        int midsem;
        int endsem;
        int attendance;
    }
    
    mapping (int => Marks) student;
    mapping (int => bool) isEnrolled;
    
    constructor(int c, address inst, address adm) public
    {
        courseNo = c;
        instructor  = inst;
        admin = adm;
        ManagerContract = msg.sender; 
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
    
    modifier onlyManagerContract
    {
        require(
            msg.sender == ManagerContract,
            "Only ManagerContract can call this function"
        );
        _;
    }
    
    function enroll(int rollNo) public onlyManagerContract
        {
            require(
                !isEnrolled[rollNo],
                "Student is already enrolled"
            );
            student[rollNo].attendance = 0;
            student[rollNo].midsem = 0;
            student[rollNo].endsem = 0;
            //update mapping
            isEnrolled[rollNo] = true;
            //This function can only be called by the ManagerContract
            //Enroll a student in the course if not already registered
        }
    
    modifier onlyInstructor
    {
        require(
            msg.sender == instructor,
            "Only instructor can call this function"
        );
        _;
    }
    
    function markAttendance(int rollNo) public onlyInstructor
    {
        require(
            isEnrolled[rollNo],
            "Student is not enrolled in course"
        );
        
        student[rollNo].attendance = student[rollNo].attendance + 1;
        //Only the instructor can mark the attendance
        //Increment the attendance variable by one
        //Make sure the student is enrolled in the course
    }
    
    function addMidSemMarks(int rollNo, int marks) public onlyInstructor
    {
        require(
            isEnrolled[rollNo],
            "Student is not enrolled in course"
        );
        
        student[rollNo].midsem = marks;
        //Only the instructor can add midsem marks
        //Make sure that the student is enrolled in the course
    }
    
    function addEndSemMarks(int rollNo, int marks) public onlyInstructor
    {
        require(
            isEnrolled[rollNo],
            "Student is not enrolled in course"
        );
        
        student[rollNo].endsem = marks;
        //Only the instructor can add endsem marks
        //Make sure that the student is enrolled in the course
    }
    
    function getMidsemMarks(int rollNo) public view onlyManagerContract returns(int)
    {
        require(
            isEnrolled[rollNo],
            "Student is not enrolled in course"
        );
        
        return student[rollNo].midsem;
        //Can only be called by the ManagerContract
        //return the midSem, endSem and attendance of the student
        //Make sure to check the student is enrolled

    }
    
    
    function getEndsemMarks(int rollNo) public view onlyManagerContract returns(int) 
    {
        require(
            isEnrolled[rollNo],
            "Student is not enrolled in course"
        );
        
        return student[rollNo].endsem;
        //Can only be called by the ManagerContract
        //return the midSem, endSem and attendance of the student
        //Make sure to check the student is enrolled

    }
    
    
    function getAttendance(int rollNo) public view onlyManagerContract returns(int)
    {
        require(
            isEnrolled[rollNo],
            "Student is not enrolled in course"
        );
        
        return student[rollNo].attendance;
        //Can only be called by the ManagerContract
        //return the midSem, endSem and attendance of the student
        //Make sure to check the student is enrolled

    }
    
    function isEnroll(int rollNo) public view returns(bool)
    {
        return isEnrolled[rollNo];
        //Returns if a roll no. is enrolled in a particular course or not
        //Can be accessed by anyone

    }
    
}


