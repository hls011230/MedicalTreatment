pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
//import "./a.sol"

contract UploadMedicalrecords is ERC20{

    address public A11Smile;
    constructor() ERC20("AS","AS") {
        A11Smile = msg.sender;
        _mint(msg.sender,20000 * 10 ** uint(1));
    }

    event Addtokens( address indexed owner, uint indexed amount);//增加代币事件
    event Uploadmedicaldata(address indexed user,string indexed route,address indexed soliciter ); //用户上传医疗信息事件
    event gainerUploadmedicaldata(string indexed route,address indexed soliciter ); //征求者上传医疗信息事件
    event reward(address indexed owner,string indexed route,uint indexed price); //征求者奖励事件
    event A11GiveETH(address indexed user1, address indexed user2,uint indexed price);//A11Smile给新用户发ETH事件
    event EthgetAs(address indexed user1, address indexed user2,uint indexed price);//ETH购买AS事件


    //增加代币
    function mint1( uint amount) public {
        _mint(msg.sender,amount ** uint(18));
        emit Addtokens(msg.sender,amount);
    }


    //用户
    struct user_Users {
        address user;
        bool exit;
    }

    //征求者地址
    struct Soliciter{
        address soliciter;
        bool exist;
    }

    //代币地址
    address ercaddress = address(this);

    //上传医疗数据信息时间
    uint public lastUpdateTime;

    //审核医疗数据时间
    uint public examineTime;


    //征求者发布医疗信息
    address[] A11soliciter;//存所有发布征求的征求者
    mapping(address =>string[]) UpMedicalName;//存储征求者征求的医疗数据名称
    mapping(address => AddName) OnlyName;//征求者地址对应医疗数据名称
    struct AddName {
        mapping(string =>gainer_upMedicalInformation) Addnames;//医疗数据名称对应首页展示
        mapping(string => gainer_upMedicalInformation1) Addneirong;//医疗数据名称对应内容
    }
    //首页展示的结构体
    struct gainer_upMedicalInformation{
        string MedicalName;
        uint min;
        uint max;
        uint account;
        string HospitalName;
        bool exit;
    }
    //展示内容的结构体
    struct gainer_upMedicalInformation1{
        uint min;  //设置最小奖励金额
        uint max;  //设置最大奖励金额
        string Medicalrecordrequirements;//病历要求
        string Requirementdescription;//需求描述
    }

    //征求者发布医疗信息方法
    function gainer_AddMedicalInformation( string memory hospitalName_,uint min_,uint max_,uint account_,string memory MedicalName_,string memory _Medicalrecordrequirements,string memory _Requirementdescription) public {
        A11soliciter.push(msg.sender);
        UpMedicalName[msg.sender].push(MedicalName_);
        OnlyName[msg.sender].Addnames[MedicalName_].MedicalName=MedicalName_;
        OnlyName[msg.sender].Addnames[MedicalName_].min=min_;
        OnlyName[msg.sender].Addnames[MedicalName_].max=max_;
        OnlyName[msg.sender].Addnames[MedicalName_].account=account_;
        OnlyName[msg.sender].Addnames[MedicalName_].HospitalName=hospitalName_;
        OnlyName[msg.sender].Addnames[MedicalName_].exit=true;
        OnlyName[msg.sender].Addneirong[MedicalName_].min=min_;
        OnlyName[msg.sender].Addneirong[MedicalName_].max=max_;
        OnlyName[msg.sender].Addneirong[MedicalName_].Medicalrecordrequirements= _Medicalrecordrequirements;
        OnlyName[msg.sender].Addneirong[MedicalName_].Requirementdescription= _Requirementdescription;
        emit gainerUploadmedicaldata(MedicalName_,msg.sender);
    }

    // 首页展示征求者征求的医疗数据
    function SeeGainerMedicalInformationsName() public view returns(gainer_upMedicalInformation[] memory){
        gainer_upMedicalInformation[] memory MediacalNameshouye = new gainer_upMedicalInformation[](A11soliciter.length);
        for (uint i=0;i < A11soliciter.length;i++){
            gainer_upMedicalInformation memory SY;
            SY.MedicalName = OnlyName[A11soliciter[i]].Addnames[UpMedicalName[A11soliciter[i]][i]].MedicalName;
            SY.min = OnlyName[A11soliciter[i]].Addnames[UpMedicalName[A11soliciter[i]][i]].min;
            SY.max = OnlyName[A11soliciter[i]].Addnames[UpMedicalName[A11soliciter[i]][i]].max;
            SY.account =OnlyName[A11soliciter[i]].Addnames[UpMedicalName[A11soliciter[i]][i]].account;
            SY.HospitalName = OnlyName[A11soliciter[i]].Addnames[UpMedicalName[A11soliciter[i]][i]].HospitalName;
            SY.exit = OnlyName[A11soliciter[i]].Addnames[UpMedicalName[A11soliciter[i]][i]].exit;
            MediacalNameshouye[i]=SY;
        }
        return MediacalNameshouye;
    }


    //用户查看征求者上传的医疗数据
    function SeeGainerMedicalInformations() public view returns(gainer_upMedicalInformation1[] memory){
        gainer_upMedicalInformation1[] memory MediacalName = new gainer_upMedicalInformation1[](A11soliciter.length);
        for (uint256 i = 0; i<A11soliciter.length; i++){
            gainer_upMedicalInformation1 memory MedicalContent;
            MedicalContent.min =OnlyName[A11soliciter[i]].Addneirong[UpMedicalName[A11soliciter[i]][i]].min;
            MedicalContent.max =OnlyName[A11soliciter[i]].Addneirong[UpMedicalName[A11soliciter[i]][i]].max;
            MedicalContent.Medicalrecordrequirements =OnlyName[A11soliciter[i]].Addneirong[UpMedicalName[A11soliciter[i]][i]].Medicalrecordrequirements;
            MedicalContent.Requirementdescription =OnlyName[A11soliciter[i]].Addneirong[UpMedicalName[A11soliciter[i]][i]].Requirementdescription;
            MediacalName[i] = MedicalContent;
        }
        return MediacalName;
    }

    //征求者查看自己发布的医疗数据名字
    function gainer_SeeOwnMedicalInformationName() public view returns(string[] memory){
        return (UpMedicalName[msg.sender]);
    }

    function bbb() public view returns(uint ){
        return(A11soliciter.length);
    }

    //一条一条的返回详情数据
    function Neirong1(address a,uint256 b) public view returns(uint256,uint256,string memory,string memory){
        return(OnlyName[a].Addneirong[UpMedicalName[a][b]].min,
        OnlyName[a].Addneirong[UpMedicalName[a][b]].max,
        OnlyName[a].Addneirong[UpMedicalName[a][b]].Medicalrecordrequirements,
        OnlyName[a].Addneirong[UpMedicalName[a][b]].Requirementdescription);
    }

    //一条一条的返回首页数据
    function Shouye1(address a,uint256 b) public view returns(string memory,uint256,uint256,uint256,string memory,bool){
        return(OnlyName[a].Addnames[UpMedicalName[a][b]].MedicalName,
        OnlyName[a].Addnames[UpMedicalName[a][b]].min,
        OnlyName[a].Addnames[UpMedicalName[a][b]].max,
        OnlyName[a].Addnames[UpMedicalName[a][b]].account,
        OnlyName[a].Addnames[UpMedicalName[a][b]].HospitalName,
        OnlyName[a].Addnames[UpMedicalName[a][b]].exit);
    }


    //征求者查看自己发布的医疗数据名字对应的内容
    // function gainer_SeeOwnMedicalInformation()public view returns(string memory Url,uint,uint,string memory,string memory){
    //    for(uint256 i=0;i<UpMedicalName.length;i++){
    //        if(OnlyName[msg.sender].Addnames[UpMedicalName[msg.sender][i]].exit=true){

    //        }
    //    }

    //     if(OnlyName[msg.sender].Addnames)
    //         return(OnlyName[]
    //          gainerUpMedicalInformation[msg.sender].MedicalRecordDetails[MedicalName].min,
    //          gainerUpMedicalInformation[msg.sender].MedicalRecordDetails[MedicalName].max,
    //          gainerUpMedicalInformation[msg.sender].MedicalRecordDetails[MedicalName].Medicalrecordrequirements,
    //          gainerUpMedicalInformation[msg.sender].MedicalRecordDetails[MedicalName].Requirementdescription);
    //   }

    //给合约转ETH
    function toContract() public payable{
    }

    //用户上传体检报告
    struct MedicalExaminationReportstrucr{
        mapping(string => string) file;
    }
    //mapping用户对应上传体检报告
    mapping(address => MedicalExaminationReportstrucr) user_MedicalExaminationReportstrucrURL;
    mapping(address => string[]) public user_MedicalExaminationReportstrucrName;
    //用户上传体检报告
    function user_UPMedicalExaminationReport(string memory name,string memory url) public {
        user_MedicalExaminationReportstrucrURL[msg.sender].file[name] = url;
        user_MedicalExaminationReportstrucrName[msg.sender].push(name);
    }
    //查看用户的体检报告量
    function viewMedicalExaminationReportCount() public view returns(uint){
        return user_MedicalExaminationReportstrucrName[msg.sender].length;
    }


    //用户上传病历信息
    struct Medicalinformation{
        mapping(string => string) file;
    }
    //mapping用户对应上传病历信息
    mapping(address => Medicalinformation) user_MedicalinformationURL;
    mapping(address => string[]) public user_MedicalinformationrName;
    //用户上传病历信息
    function user_UPMedicalinformation(string memory name,string memory url) public {
        user_MedicalinformationURL[msg.sender].file[name] = url;
        user_MedicalinformationrName[msg.sender].push(name);
    }
    //查看用户的病历信息量
    function viewMedicalinformationCount() public view returns(uint){
        return user_MedicalinformationrName[msg.sender].length;
    }


    //用户上传医疗数据
    struct user_MedicalCertificate{
        address user;
        string[] PictureRoute;
        address soliciter;
    }
    //mapping用户对应上传医疗数据信息
    mapping (address => user_MedicalCertificate) private userAmedicalInformation;

    //征求者审核
    struct gainer_examine{
        address soliciter;
        address user;
        string pRoute;
        bool  whether;
    }

    //modified上传时间
    modifier user_upTime(address _user){
        lastUpdateTime = block.timestamp;

        _;
    }

    //modified审核时间
    modifier gainer_examineTime(address soliciter){
        examineTime = block.timestamp;

        _;
    }

    //mapping对应用户
    mapping (address => user_Users)  private Ausers;

    //mapping对应征求者
    mapping(address => Soliciter) private Adoctor;

    //mapping征求者对应查询医疗数据信息
    mapping(address => user_MedicalCertificate) private gainAmedicalInformation;

    //mapping征求者审核自己的病历信息
    mapping(address => gainer_examine ) private gainerExamine;
    mapping(string => user_MedicalCertificate ) private gainerExamineString;

    //mapping查询医疗数据是否通过
    mapping(string => gainer_examine ) private userExamineString;

    //初始化由A11Smile给用户ETH
    function A11SmileGiveETH(address payable Startuse) public payable  {
        require(msg.sender == A11Smile, "you not can transfer");
        require(msg.sender.balance > msg.value,"Your account doesn't have so much ETH");
        Startuse.transfer(msg.value);
        emit A11GiveETH(msg.sender,Startuse,msg.value);
    }


    //设置用户
    function user_Adduser(address _user) public{
        require(!user_IsUser(_user),"User is exit");
        Ausers[_user].user= _user;
        Ausers[_user].exit= true;
    }

    //设置征求者
    function gainer_setDoctor(address soliciter) public{
        require(!gainer_isDoctor(soliciter),"Soliciter is exit");
        Adoctor[soliciter].soliciter=soliciter;
        Adoctor[soliciter].exist=true;
    }


    //用户上传证书
    function user_AddMedicalInformation(string memory Proute,address _soliciter) public user_upTime(msg.sender) {
        require(gainer_isDoctor(_soliciter),"Soliciter no exist");
        userAmedicalInformation[msg.sender].PictureRoute.push(Proute);
        userAmedicalInformation[msg.sender].soliciter=_soliciter;
    }

    //查询用户是否存在
    function user_IsUser(address _user) public view returns(bool){
        return Ausers[_user].exit;
    }

    //查询征求者是否存在
    function gainer_isDoctor(address soliciter)public view returns(bool){
        return Adoctor[soliciter].exist;
    }

    //用户查看用户上传的证书
    function user_ViewMedicalRecords() public view returns(string[] memory,address soliciter){
        return (userAmedicalInformation[msg.sender].PictureRoute,userAmedicalInformation[msg.sender].soliciter);
    }

    //用户查看用户上传的体检报告
    function user_ViewMedicalExaminationReport(string memory name) public view returns(string memory){
        return user_MedicalExaminationReportstrucrURL[msg.sender].file[name];
    }

    //用户查看用户上传的医疗信息
    function user_ViewMedicalInformation(string memory name) public view returns(string memory){
        return  user_MedicalinformationURL[msg.sender].file[name];
    }

    //征求者查看用户上传给自己的证书
    function  gainer_doctorsee(address soliciter) public view returns(address,string[] memory,address){
        return (gainAmedicalInformation[soliciter].user,gainAmedicalInformation[soliciter].PictureRoute,gainAmedicalInformation[soliciter].soliciter);
    }

    //设置代币地址
    function A11Smile_setErc(address ercaddress_) public{
        ercaddress=ercaddress_;
    }

    //征求者审核,奖励
    function gainer_whether(address _soliciter,string memory PictureRoute,bool whether,uint ercnum_) public gainer_examineTime(_soliciter){
        gainerExamine[_soliciter].soliciter=_soliciter;
        gainerExamine[_soliciter].user=gainerExamineString[PictureRoute].user;
        gainerExamine[_soliciter].pRoute=PictureRoute;
        require(_soliciter==gainerExamineString[PictureRoute].soliciter,"The medical data does not belong to the soliciter");
        if(whether==true){
            gainerExamine[_soliciter].whether = true;
            gainer_transfer_AS(gainerExamineString[PictureRoute].soliciter,gainerExamineString[PictureRoute].user,ercnum_);
        }else{
            revert("Failed to pass the review");
        }
        emit reward(_soliciter,PictureRoute,ercnum_);

    }


    //征求者奖励,奖励AS代币
    function gainer_transfer_AS(address from1 ,address to1,uint quantity1) public {
        ERC20.transferFrom(from1,to1,quantity1);
    }

    //查看证书是否通过审核
    function seeMedicaldata(string memory PictureRoute) public view returns(string memory,bool){
        return(PictureRoute,userExamineString[PictureRoute].whether);
    }

    //查看当前账户的ETH
    function getUserETH() public view returns(uint) {
        return msg.sender.balance;
    }

    //查看当前账户的AS
    function getUserAS() public view returns(uint) {
        return balanceOf(msg.sender);
    }

    //ETH购买AS
    function EthGetAs(address payable AddEth,address payable RedEth) public payable {
        AddEth.transfer(msg.value);
        _mint1(AddEth,RedEth,msg.value);
        emit EthgetAs(msg.sender,AddEth,msg.value);
    }


    function _mint1(address from,address to,uint account)  internal virtual{
        uint balance1 = balanceOf(from);
        require(balance1 >2 *account,"Not so many as");
        _transfer(from,to,2*account);

    }




}
