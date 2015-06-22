var UserForm = React.createClass({
  propTypes: {
    sciper: React.PropTypes.string,
    name: React.PropTypes.string,
    role: React.PropTypes.string,
    email: React.PropTypes.string
  },
  getInitialState: function(){
    return {
      sciper: '',
      name: '',
      role: '',
      email: '',
      errors: {}
    };
  },
  handleChange: function(e){
    var name = e.target.name;
    var stateChanger = {};
    stateChanger[name] = e.target.value;
    this.setState(stateChanger);
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
      user: this.state
    }, success, 'JSON').fail(error);
  },
  valid: function(){
    var emailValid = /^[\w\.-_\d]+@epfl\.ch$/.test(this.state.email);
    return emailValid;
  },
  render: function() {
    return (
      <form action="" className="form-inline" onSubmit={this.handleSubmit}>
        <div className="errors">
          {Object.keys(this.state.errors).map(function(key){
              return key + " " + this.state.errors[key][0];
          })}
        </div>
        <div className="form-group">
            <div className="form-group">
              <input type="text" className="form-control" placeholder="sciper" name="sciper" value={this.state.sciper} onChange={this.handleChange}/>
            </div>
            <div className="form-group">
              <input type="text" className="form-control" placeholder="Email" name="email" value={this.state.email} onChange={this.handleChange}/>
            </div>
            <div className="form-group">
              <input type="text" className="form-control" placeholder="Name" name="name" value={this.state.name} onChange={this.handleChange}/>
            </div>
            <div className="form-group">
              <input type="text" className="form-control" placeholder="role" name="role" value={this.state.role} onChange={this.handleChange}/>
            </div>
          <button className="btn btn-primary" type="submit" disabled={!this.valid()}>Add User</button>
        </div>
      </form>
    );
  }
});
