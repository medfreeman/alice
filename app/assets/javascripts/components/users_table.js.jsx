var UsersTable = React.createClass({
	getInitialState: function(){
		return {
			users: this.props.users,
			displayedUsers: this.props.users,
			studios: this.props.studios,
			currentUser: this.props.currentUser,
			currentFilterStudio: null,
		}
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
		else if(value == 'unassigned')
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
				return user.studio && user.studio.name == value;
			});
			this.setState({
				filteredByStudio: true,
				displayedUsers: users_,
				currentFilterStudio: value
			});
		}
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
			$.ajax({
				url: '/admin/users/'+userId,
				method: 'PATCH',
				data: data, 
				success: success
			});
		};
		var updateUser = function(property){
			var userId = user.id;
			return function(value){
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

		var userEmail, userName, editButton;
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
			userName = user.name;
			userEmail = user.email;
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
			<Reactable.Tr className={"user ui form " + user.role} key={user.id} data={user} data-user-id={user.id}>
				<Reactable.Td column="name_">
					{userName}
				</Reactable.Td>
				<Reactable.Td column="email_">
					{userEmail}
				</Reactable.Td>
				<Reactable.Td column="role_">
					<Select 
						name='role' 
						value={user.role} 
						options={that.props.roles.map(function(role){
							return {value: role, label: role};
						})} 
						onChange={updateUser('role')}
						searchable={false} 
						clearable={false}
					/>
				</Reactable.Td>
				<Reactable.Td column="studio_">
					<Select
						className="not-field"
						clearable={true}
						name='studio' 
						value={user.studio ? user.studio.name : null} 
						options={that.state.studios.map(function(s){return {value:s.id, label:s.name};})} 
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
	updateUsersWith: function(users_){
	  this.filterByStudio(this.state.currentFilterStudio);
	  this.props.updateUsersWith(users_);
	  console.log("users_:", users_);
	  this.setState({users: users_});
	},
  render: function() {
  	var that = this;
    return <div>
    		<Select 
						name='filterStudio'
						value={this.state.currentFilterStudio}
						options={[{value: 'unassigned', label: 'unassigned'}].concat(that.state.studios.map(function(s){return {value:s.name, label:s.name};}))} 
						onChange={this.filterByStudio}
						placeholder="Filter by studio..."
					/>
					<Table className="ui table striped compact "  columns={[
						{
							key: 'sciper',
							label: 'SCIPER'
						},
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
							key: 'studio_',
							label: 'Studio'
						},
						{
							key: 'actions', 
							label: 'Actions'
						}
						]} 
						sortable={['name_', 'email_', 'role_', 'studio_']} 
						filterable={['email', 'name', 'sciper']} 
						filterPlaceholder="Filter by user...">
						{ 
							this.state.displayedUsers.map(function(user, index){
								return that.userTr(user);
							})
						}
					</Table>
				</div>;
  }
});
