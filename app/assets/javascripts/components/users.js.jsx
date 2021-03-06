var Table = Reactable.Table;


var Users = React.createClass({
	getChildContext() {
		return {currentUser: this.props.current_user};
	},
	componentDidMount: function(){
		$('.tabular.menu .item').tab();
	},
	getInitialState: function(){
		var currentStudio = this.props.current_user.studio;
		function studioUsers(studio, users){
			return _.filter(users, function(user){
				if(!user.studio){
					return true;
				}
				return user.studio.id == studio.id;
			})
		};
		var users_, currentFilterStudio;
		if(currentStudio){
			users_ = studioUsers(currentStudio, this.props.users);
			currentFilterStudio = currentStudio;
		}
		else{
			users_ = this.props.users;
		}
		return {
			currentUser: this.props.current_user,
			users: this.props.users,
			displayedUsers: users_,
			roles: this.props.roles,
			studios: this.props.studios,
			filteredByStudio: true,
			currentFilterStudio: currentFilterStudio,
			year: $('meta[description="alice-year"]').attr('content'),
		};
	},
	getDefaultProps: function(){
		return {
			users: []
		};
	},
	updateUsersWith: function(users_){
		this.setState({users: users_});
	  this.filterByStudio(this.state.currentFilterStudio);
	},
	filterByStudio: function(value){
		if(!value)
		{
			this.setState({
				filteredByStudio: false,
				displayedUsers: this.state.users,
				currentFilterStudio: undefined
			});
		}
		else if(value.value == 'unassigned')
		{
			var users_ = _.filter(this.state.users, function(user){
				return !user.studio;
			});
			this.setState({
				filteredByStudio: true,
				displayedUsers: users_,
				currentFilterStudio: value
			});
		}
		else
		{
			var users_ = _.filter(this.state.users, function(user){
				return user.studio && user.studio.id == value.value;
			});
			this.setState({
				filteredByStudio: true,
				displayedUsers: users_,
				currentFilterStudio: value
			});
		}
	},
	addUser: function(user){
		var users_ = React.addons.update(this.state.users, { $unshift: [user] })
		this.updateUsersWith(users_);
	},
	addStudio: function(studio){
		console.log("studio:", studio);
		var studios_ = React.addons.update(this.state.studios, { $unshift: [studio] })
		this.setState({
			studios: studios_
		});
	},
	deleteUser: function(user){
		var that = this;
		$.ajax({
			url: "/admin/years/"+that.state.year+"/users/"+user.id,
			method: 'delete',
			success: function(res){
		    var index = that.state.users.indexOf(user);
				var users_ = React.addons.update(that.state.users, { $splice: [[index, 1]] })
				that.setState({users: users_});
				that.filterByStudio(that.state.currentFilterStudio);
			},
		});
	},
	createStudio: function(studioName){
		var that = this;
		console.log("studioName:", studioName);
		$.ajax({
			href: 'studios',
			data: {
				name: studioName,
				year_id: that.state.year
			},
			success: function(res){
				var studios = that.state.studios.splice();
				studios.push(res);
				that.setState(studios);
			},
		});
		var studios = this.state.studios.splice();
	},
	userTr: function(user){
		var that = this;
		var deleteUser = function(){
			that.deleteUser(user);
		};
		var ajaxUpdateUser = function(userId, data){
			var success = function(res){
	      var index = that.state.users.indexOf(user);
	      var users_ = React.addons.update(that.state.users, { $splice: [[index, 1, res.user]] });
	      that.updateUsersWith(users_);
			};
			that.setState({
        	errors: {}
      });
			var error = function(res){
 				that.setState({
        	errors: res.responseJSON
      });
      console.log("data:", that.state.errors);
			};
			$.ajax({
				url: '/admin/years/'+that.state.year+'/users/'+userId,
				method: 'PATCH',
				data: data,
				success: success,
				error: error
			});
		};
		var updateUser = function(property, checkbox){
			var userId = user.id;
			return function(value){
				if(checkbox){
					value = value.currentTarget.checked
				}
				else if(value){

					value = typeof value == 'string' ? value : value.value
				}
				var user = _.find(that.state.users, function(user_){
					return user_.id == userId;
				});
				var data = {
					user: {}
				};
				console.log("updateUser value:", value);
				data.user[property] = value;
				ajaxUpdateUser(userId, data);
			}
		};
		var saveUser = function(e){
			var userRow = $(e.target).parents('tr');
			var data = {
				user: {
					name: $('input[name="user[name]"]', userRow).val(),
					email: $('input[name="user[email]"]', userRow).val(),
				}
			};
			ajaxUpdateUser(user.id, data);
			editUserToggle();
		}
		var editUserToggle = function(){
			user.editable = !user.editable;
			var index = that.state.users.indexOf(user);
      var users_ = React.addons.update(that.state.users, { $splice: [[index, 1, user]] });
      that.updateUsersWith(users_);
		};

		var userEmail, userName, superStudent, editButton;
		if(user.editable)
		{
			userName = <div className="field"><input type="text" defaultValue={user.name} name="user[name]"/></div>;
			userEmail = <div className="field"><input type="text" defaultValue={user.email} name="user[email]"/></div>;
			editButton = (
				<button className="ui button mini green" onClick={saveUser}>
					Save
				</button>
			);
		}
		else
		{
			editButton = (
				<button className="ui button mini" onClick={editUserToggle}>
					Edit
				</button>
			);
			userName = <div>{user.name}</div>;
			userEmail = <div>{user.email}</div>;
		}
		var deleteButton;
		if(user.id != that.state.currentUser.id && !user.editable)
		{
			deleteButton = (
				<button className="ui button mini basic red" onClick={deleteUser}>
					Delete
				</button>
			);
		}
		var actions = (
			<div className="actions">
				{editButton}
				{deleteButton}
			</div>
		);
		return (
			<Reactable.Tr className={"user ui form " + user.role} key={user.id} data={user} data-user-id={user.id} onDoubleClick={editUserToggle}>
				<Reactable.Td column="name_">
					{userName}
				</Reactable.Td>
				<Reactable.Td column="email_">
					{userEmail}
				</Reactable.Td>
				<Reactable.Td column="role_">
					<Select
						className='role-field'
						name='role'
						value={user.role}
						options={that.props.roles.map(function(role){
							return {value: role, label: role};
						})}
						onChange={updateUser('role')}
						seaarchable={false}
						clearable={false}
					/>
				</Reactable.Td>
				<Reactable.Td column="super_student_">
					<div>
						{user.super_student}
						<input
							id={user.id + '-super_student'}
							type="checkbox"
							name="user[super_student]"
							checked={user.super_student}
							onChange={updateUser('super_student', 'checkbox')}/>
          	<label htmlFor={user.id + '-super_student'}>&nbsp;</label>
          </div>
				</Reactable.Td>
				<Reactable.Td column="studio_">
					<Select
						className="not-field"
						clearable={true}
						name='studio'
						value={user.studio != undefined ? user.studio.id : null}
						options={that.state.studios.map(function(s){
							return {value:s.id, label:s.name};
						})}
						onChange={updateUser('studio')}
						placeholder="Select studio..."
					/>
				</Reactable.Td>
				<Reactable.Td column="actions">
					{actions}
				</Reactable.Td>
			</Reactable.Tr>
		);
	},
	handleStudios: function(studios){
		this.setState({
			studios: studios,
		});
	},
	render: function(){
		var that = this;
		return (
			<div className="users-table">
				<h2 className="title">Manage {that.props.year}</h2>
				<div className="ui tabular menu">
					<div className="item active" data-tab="users-list">Users</div>
					<div className="item" data-tab="studios-list">Studios</div>
				  <div className="item right">
				  	<a href={'/admin/years/'+ that.props.year + "/users/upload"}>
				  		upload csv file for {that.props.year}
				  		<i className="icon external"></i>
				  	</a>
				  </div>
				</div>
				<div className="ui tab" data-tab="studios-list">
					<StudiosTable
						studios={this.state.studios}
						handleStudios={this.handleStudios}
						handleNewStudio={this.addStudio}
					/>
				</div>
				<div className="ui tab" data-tab="add-user">
					<UserForm handleNewUser={this.addUser} roles={this.state.roles} studios={this.state.studios}/>
				</div>
				<div className="ui tab active" data-tab="users-list">
					<FormErrors errors={this.state.errors}/>
					<Select
						name='filterStudio'
						value={this.state.currentFilterStudio && this.state.currentFilterStudio.value}
						options={[{value: 'unassigned', label: 'unassigned'}].concat(that.state.studios.map(function(s){return {value:s.id, label:s.name};}))}
						onChange={this.filterByStudio}
						placeholder="Filter by studio..."
					/>
					<Table className="ui table striped compact "  columns={[
						{
							key: 'name_',
							label: 'Name'
						},
						{
							key: 'email_',
							label: 'Email'
						},
						{
							key: 'role_',
							label: 'Role'
						},
						{
							key: 'super_student_',
							label: 'Super Student'
						},
						{
							key: 'studio_',
							label: 'Studio'
						},
						{
							key: 'actions',
							label: 'Actions'
						}
						]} sortable={['name_', 'email_', 'role_', 'studio_']} filterable={['email', 'name', 'sciper']} filterPlaceholder="Filter by user..."
					>
						{this.state.displayedUsers.map(function(user, index){
							return that.userTr(user);
						})}
					</Table>
					<UserForm roles={this.state.roles} studios={this.state.studios} handleNewUser={this.addUser} currentStudio={this.state.currentFilterStudio}/>
				</div>
			</div>
		);
	},
});
Users.childContextTypes = {
  currentUser: React.PropTypes.any
};
