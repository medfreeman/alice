var Table = Reactable.Table;
var Tr = Reactable.Tr;
var Td = Reactable.Td;

var UserForm = React.createClass({
  propTypes: {
    sciper: React.PropTypes.string,
    name: React.PropTypes.string,
    role: React.PropTypes.string,
    email: React.PropTypes.string,
    super_student: React.PropTypes.bool
  },
  getInitialState: function(){
    return {
      sciper: '',
      name: '',
      role: 'student',
      super_student: false,
      studio: '',
      email: '',
      roles: this.props.roles,
      studios: this.props.studios,
      errors: {},
      year: $('meta[description="alice-year-id"]').attr('content'),
    };
  },
  handleChange: function(e){
    var name = e.target.name;
    var stateChanger = {};
    stateChanger[name] = e.target.value;
    this.setState(stateChanger);
  },
  handleRoleChange: function(value){
    this.setState({
      role: value
    });
  },
  handleStudioChange: function(value){
    this.setState({
      studio: value
    });
  },
  handleSubmit: function(e){
    e.preventDefault();
    var that = this;
    var success = function(data) {
      that.props.handleNewUser(data);
      that.setState(that.getInitialState())
    };
    var error = function(data){
      that.setState({
        errors: data.responseJSON
      });
      console.log("data:", that.state.errors);

    };
    $.post('users/create', {
      user: {
        email: this.state.email,
        name: this.state.name,
        sciper: this.state.sciper,
        role: this.state.role,
        studio: this.state.studio,
        super_student: this.state.super_student,
        year_id: this.state.year
      },
    }, success, 'JSON').fail(error);
  },
  valid: function(){
    var emailValid = /^[\w-–_\.\d]+@epfl\.ch$/.test(this.state.email);
    return emailValid && this.state.name;
  },
  render: function() {
    return (
      <form action="" className="ui form" onSubmit={this.handleSubmit}>
      <table>
        <tbody>
          <tr>
            <FormErrors errors={this.state.errors}/>

              <td className="field">
                <input type="text" placeholder="Name*" name="name" value={this.state.name} onChange={this.handleChange}/>
              </td>
              <td className="field">
                <input type="text" placeholder="Email*" name="email" value={this.state.email} onChange={this.handleChange}/>
              </td>
              <td>
                <Select
                  className="not-field"
                  name="role"
                  value={this.state.role}
                  options={this.props.roles.map(function(r){
                    return {value: r, label: r};
                  })}
                  clearable={false}
                  searchable={false}
                  onChange={this.handleRoleChange}
                />
              </td>
              <td className="field">
                <input id="super_student" type="checkbox" name="super_student" value={this.state.super_student} onChange={this.handleChange}/>
                <label htmlFor="super_student">Super Student</label>
              </td>
              <td>
                <Select
                  className="not-field"
                  name="studio"
                  value={this.state.studio}
                  options={this.props.studios.map(function(s){
                    return {value: s.name, label: s.name};
                  })}
                  clearable={false}
                  onChange={this.handleStudioChange}
                />
              </td>
              <td>
                <button className="ui button" type="submit" disabled={!this.valid()}>
                  <i className="add icon"></i>
                  Add User
                </button>
              </td>
            </tr>
          </tbody>
        </table>
        <div>
        The user will receive an email from which he can select his password.
        </div>
      </form>
    );
  }
});
